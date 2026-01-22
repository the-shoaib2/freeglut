#!/usr/bin/env node

const { Command } = require('commander');
const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');
const fetch = require('node-fetch');
const tar = require('tar');
const { execSync, spawn } = require('child_process');
const os = require('os');
const chokidar = require('chokidar');
const pkg = require('./package.json');

const program = new Command();

const FREEGLUT_VERSION = '3.8.0';
const DOWNLOAD_URL = `https://github.com/freeglut/freeglut/releases/download/v${FREEGLUT_VERSION}/freeglut-${FREEGLUT_VERSION}.tar.gz`;

program
    .name('glut')
    .description(chalk.cyan('🚀 FreeGLUT Project Framework CLI'))
    .version(pkg.version, '-v, --version', 'Output the current version');

// Custom stylized help
program.addHelpText('after', `
${chalk.blue('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')}
${chalk.yellow('Examples:')}
  ${chalk.gray('$')} glut create Project
  ${chalk.gray('$')} glut build --release
  ${chalk.gray('$')} glut watch
  ${chalk.gray('$')} glut add PlayerController
${chalk.blue('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')}
`);

// Explicit version command
program
    .command('version')
    .description('Display the current version of glut CLI')
    .action(() => {
        console.log(chalk.cyan(`glut CLI ${chalk.bold('v' + pkg.version)}`));
    });

program
    .command('setup')
    .description('Setup FreeGLUT environment')
    .action(async () => {
        const platform = process.platform;
        console.log(chalk.cyan(`Setting up FreeGLUT ${FREEGLUT_VERSION} for ${platform}...`));

        if (platform === 'win32') {
            await setupWindows();
        } else if (platform === 'darwin') {
            await setupMacOS();
        } else if (platform === 'linux') {
            await setupLinux();
        } else {
            console.log(chalk.red(`Unsupported platform: ${platform}`));
        }
    });

program
    .command('create [project-name...]')
    .description('Create a new FreeGLUT project from template')
    .action(async (projectNameArray) => {
        let projectName = projectNameArray && projectNameArray.length > 0
            ? projectNameArray.join(' ')
            : 'Project';

        const root = path.resolve(projectName);
        const appName = path.basename(root);
        const displayPath = path.relative(process.cwd(), root) || '.';

        if (fs.existsSync(root)) {
            console.log(chalk.red(`\n✖ Error: Directory '${projectName}' already exists.`));
            process.exit(1);
        }

        console.log(chalk.blue('\n' + '━'.repeat(60)));
        console.log(chalk.cyan(`🚀 Creating a new FreeGLUT app: ${chalk.bold(appName)}`));
        console.log(chalk.blue('━'.repeat(60) + '\n'));

        await fs.ensureDir(root);

        const templateDir = path.join(__dirname, 'template');
        if (!fs.existsSync(templateDir)) {
            console.log(chalk.red('✖ Error: Template directory not found. Please ensure the CLI is installed correctly.'));
            process.exit(1);
        }

        // Copy template files
        await fs.copy(templateDir, root);

        // Rename _gitignore to .gitignore (npm pack excludes .gitignore by default)
        const gitignorePath = path.join(root, '_gitignore');
        if (fs.existsSync(gitignorePath)) {
            await fs.move(gitignorePath, path.join(root, '.gitignore'));
        }

        // Update glut.json name
        const configPath = path.join(root, 'glut.json');
        if (fs.existsSync(configPath)) {
            const config = await fs.readJson(configPath);
            config.name = appName;
            await fs.writeJson(configPath, config, { spaces: 2 });
        }

        // Inject Project Name into main.cpp
        const mainPath = path.join(root, 'main.cpp');
        if (fs.existsSync(mainPath)) {
            let content = await fs.readFile(mainPath, 'utf8');
            content = content.replace(/glutCreateWindow\(".*"\)/, `glutCreateWindow("${appName}")`);
            await fs.writeFile(mainPath, content);
        }

        console.log(chalk.green('✔ Successfully scaffolded project structure.'));

        // Git initialization
        try {
            execSync('git init', { cwd: root, stdio: 'ignore' });
            console.log(chalk.green('✔ Initialized local Git repository.'));
        } catch (e) {
            console.log(chalk.yellow('⚠ Could not initialize Git repository. Skipping.'));
        }

        console.log(chalk.green('✔ VS Code configurations initialized.'));

        console.log(chalk.blue('\n' + '━'.repeat(60)));
        console.log(chalk.green.bold('✨ Success! ') + `Project ${chalk.bold(appName)} is ready.`);
        console.log(chalk.blue('━'.repeat(60)));

        console.log(`\nTo get started, run:`);
        console.log(chalk.yellow(`  cd "${displayPath}"`));
        console.log(chalk.yellow(`  code .`));
        console.log(chalk.gray(`\nInside VS Code, press ${chalk.bold('F5')} to build and run your app.`));
        console.log(chalk.blue('━'.repeat(60) + '\n'));
    });

program
    .command('build')
    .description('Build the current project (cross-platform)')
    .option('-r, --release', 'Build with optimizations (-O3)', false)
    .action(async (options) => {
        checkInProject();
        try {
            await performBuild(options.release);
        } catch (e) {
            process.exit(1);
        }
    });

program
    .command('run')
    .description('Build and run the current project')
    .option('-r, --release', 'Run optimized release build', false)
    .action(async (options) => {
        checkInProject();
        try {
            const exe = await performBuild(options.release);
            console.log(chalk.cyan(`🚀 Launching ${path.basename(exe)}...`));
            console.log(chalk.gray('--- Program Output ---'));
            execSync(`"${exe}"`, { stdio: 'inherit' });
        } catch (err) {
            // Error reported by build step
        }
    });

let appProcess = null;
program
    .command('watch')
    .description('Rebuild and restart the app on file changes')
    .action(async () => {
        checkInProject();
        console.log(chalk.cyan('👀 Watch mode active. Monitoring for changes...\n'));

        const restartApp = async () => {
            if (appProcess) {
                console.log(chalk.yellow('\n♻  Change detected, restarting...'));
                if (process.platform === 'win32') {
                    execSync('taskkill /f /t /im app.exe', { stdio: 'ignore' });
                } else {
                    appProcess.kill();
                }
            }

            try {
                const exe = await performBuild(false);
                appProcess = spawn(`"${exe}"`, [], { stdio: 'inherit', shell: true });
            } catch (err) {
                console.log(chalk.red('\n✖ Automatic build failed. Fix the errors to resume.'));
            }
        };

        await restartApp();

        const watcher = chokidar.watch(['*.cpp', '*.h'], {
            ignored: /(^|[\/\\])\../,
            persistent: true
        });

        watcher.on('change', async () => {
            await restartApp();
        });
    });

program
    .command('add <name>')
    .description('Generate a new C++ component (header and source)')
    .action(async (name) => {
        checkInProject();
        const headerPath = path.resolve(`${name}.h`);
        const sourcePath = path.resolve(`${name}.cpp`);

        if (fs.existsSync(headerPath) || fs.existsSync(sourcePath)) {
            console.log(chalk.red(`✖ Error: Component '${name}' already exists.`));
            process.exit(1);
        }

        const appName = path.basename(process.cwd());
        const headerGuard = `${name.toUpperCase()}_H`;

        const headerBanner = `/*\n * ${name}.h - Component for ${appName}\n */`;
        const headerContent = `${headerBanner}\n\n#ifndef ${headerGuard}\n#define ${headerGuard}\n\n#ifdef __APPLE__\n#include <GLUT/glut.h>\n#else\n#include <GL/glut.h>\n#endif\n\nclass ${name} {\npublic:\n    ${name}();\n    void draw();\n};\n\n#endif\n`;
        const sourceContent = `${headerBanner}\n\n#include "${name}.h"\n#include <iostream>\n\n${name}::${name}() {\n    // Constructor\n}\n\nvoid ${name}::draw() {\n    // Drawing logic here\n}\n`;

        await fs.writeFile(headerPath, headerContent);
        await fs.writeFile(sourcePath, sourceContent);

        console.log(chalk.green(`\n✔ Created ${chalk.bold(name + '.h')}`));
        console.log(chalk.green(`✔ Created ${chalk.bold(name + '.cpp')}`));
        console.log(chalk.cyan(`\nNew component added to the project. It will be picked up automatically on next build.`));
    });

program
    .command('clean')
    .description('Clean build artifacts')
    .action(async () => {
        checkInProject();
        if (fs.existsSync('build')) {
            console.log(chalk.yellow('🧹 Cleaning build artifacts...'));
            await fs.remove('build');
            console.log(chalk.green('✔ Project cleaned.'));
        } else {
            console.log(chalk.gray('Nothing to clean.'));
        }
    });

program
    .command('status')
    .description('Show project information')
    .action(async () => {
        checkInProject();
        const config = await fs.readJson('glut.json');
        console.log(chalk.blue('\n' + '━'.repeat(60)));
        console.log(chalk.cyan(`Project: ${chalk.bold(config.name)}`));
        console.log(chalk.cyan(`Version: ${config.version}`));
        console.log(chalk.cyan(`Type:    ${config.type}`));
        console.log(chalk.blue('━'.repeat(60)));

        const files = await fs.readdir('.');
        const cppFiles = files.filter(f => f.endsWith('.cpp'));
        console.log(chalk.gray(`Source files (${cppFiles.length}): ${cppFiles.join(', ')}`));
        console.log(chalk.blue('━'.repeat(60) + '\n'));
    });

function checkInProject() {
    if (!fs.existsSync('glut.json')) {
        console.log(chalk.red('\n✖ Error: Not a FreeGLUT project (missing glut.json).'));
        console.log(chalk.gray('Navigate to your project folder or use "glut create" to start a new one.'));
        process.exit(1);
    }
}

async function performBuild(isRelease) {
    const platform = process.platform;
    const mode = isRelease ? 'Release' : 'Debug';
    const buildDir = path.resolve('build');
    const objDir = path.join(buildDir, 'obj');

    console.log(chalk.cyan(`🔨 Building project for ${platform} [${mode}]...`));

    try {
        await fs.ensureDir(objDir);

        const flags = isRelease ? '-O3 -s' : '-g';
        const std = '-std=c++17';
        const files = (await fs.readdir('.')).filter(f => f.endsWith('.cpp'));

        const objFiles = [];
        const compileTasks = [];
        let needsLinking = false;

        for (const file of files) {
            const ext = platform === 'win32' ? '.obj' : '.o';
            const objFile = path.join(objDir, path.basename(file, '.cpp') + ext);
            objFiles.push(objFile);

            const fileStat = await fs.stat(file);
            let objStat = null;
            try { objStat = await fs.stat(objFile); } catch (e) { }

            if (!objStat || fileStat.mtime > objStat.mtime) {
                needsLinking = true;
                compileTasks.push((async () => {
                    console.log(chalk.gray(`  Compiling ${file}...`));
                    let compileCmd = '';
                    if (platform === 'win32') {
                        compileCmd = `g++ -c "${file}" -o "${objFile}" -I"C:\\freeglut\\include" ${flags} ${std}`;
                    } else if (platform === 'darwin') {
                        compileCmd = `clang++ -c "${file}" -o "${objFile}" -DGL_SILENCE_DEPRECATION ${flags} ${std}`;
                    } else {
                        compileCmd = `g++ -c "${file}" -o "${objFile}" ${flags} ${std}`;
                    }
                    return new Promise((resolve, reject) => {
                        try {
                            execSync(compileCmd, { stdio: 'inherit' });
                            resolve();
                        } catch (e) {
                            reject(e);
                        }
                    });
                })());
            }
        }

        if (compileTasks.length > 0) {
            await Promise.all(compileTasks);
        }

        const exe = platform === 'win32' ? path.join(buildDir, 'app.exe') : path.join(buildDir, 'app');
        if (!fs.existsSync(exe)) needsLinking = true;

        if (needsLinking) {
            console.log(chalk.yellow(`  Linking ${mode} binary...`));
            let linkCmd = '';
            const objsStr = objFiles.map(f => `"${f}"`).join(' ');

            if (platform === 'win32') {
                linkCmd = `g++ ${objsStr} -o "${exe}" -L"C:\\freeglut\\lib" -lfreeglut -lopengl32 -lglu32 ${flags}`;
            } else if (platform === 'darwin') {
                linkCmd = `clang++ ${objsStr} -o "${exe}" -framework GLUT -framework OpenGL ${flags}`;
            } else {
                linkCmd = `g++ ${objsStr} -o "${exe}" -lglut -lGL -lGLU ${flags}`;
            }

            execSync(linkCmd, { stdio: 'inherit' });
            console.log(chalk.green(`\n✔ ${mode} build successful!`));
        } else {
            console.log(chalk.green('\n✔ Project is up to date.'));
        }
        return exe;
    } catch (err) {
        console.log(chalk.red('\n✖ Build failed. Check your code or dependencies.'));
        throw err;
    }
}

async function setupWindows() {
    const targetDir = 'C:\\freeglut';
    console.log(chalk.yellow(`Target directory: ${targetDir}`));

    try {
        if (!fs.existsSync(targetDir)) {
            await fs.ensureDir(targetDir);
        }

        const tarPath = path.join(os.tmpdir(), `freeglut-${FREEGLUT_VERSION}.tar.gz`);

        console.log(chalk.yellow('Downloading FreeGLUT source...'));
        const response = await fetch(DOWNLOAD_URL);
        if (!response.ok) throw new Error(`Failed to fetch: ${response.statusText}`);

        const fileStream = fs.createWriteStream(tarPath);
        await new Promise((resolve, reject) => {
            response.body.pipe(fileStream);
            response.body.on('error', reject);
            fileStream.on('finish', resolve);
        });

        console.log(chalk.yellow('Extracting to C:\\freeglut...'));
        await tar.x({
            file: tarPath,
            C: targetDir,
            strip: 1
        });

        await fs.remove(tarPath);
        console.log(chalk.green('FreeGLUT setup completed on Windows.'));
        console.log(chalk.blue('Note: You may need to compile it or provide precompiled binaries in this folder.'));
    } catch (err) {
        console.error(chalk.red(`Setup failed: ${err.message}`));
        if (err.code === 'EPERM') {
            console.log(chalk.yellow('Try running the terminal as Administrator.'));
        }
    }
}

async function setupMacOS() {
    console.log(chalk.yellow('Checking for FreeGLUT via Homebrew...'));
    try {
        execSync('brew install freeglut', { stdio: 'inherit' });
        console.log(chalk.green('FreeGLUT installed via Homebrew.'));
    } catch (err) {
        console.log(chalk.yellow('Homebrew not found or failed. Ensure FreeGLUT is installed manually.'));
        console.log(chalk.gray('Recommended: brew install freeglut'));
    }
}

async function setupLinux() {
    console.log(chalk.yellow('Attempting to install FreeGLUT via apt...'));
    try {
        execSync('sudo apt-get update && sudo apt-get install -y freeglut3-dev', { stdio: 'inherit' });
        console.log(chalk.green('FreeGLUT installed via apt.'));
    } catch (err) {
        console.log(chalk.yellow('Failed to install via apt. Ensure freeglut3-dev is installed.'));
    }
}

program.parse(process.argv);
