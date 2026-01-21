#!/usr/bin/env node

const { Command } = require('commander');
const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');
const fetch = require('node-fetch');
const tar = require('tar');
const { execSync } = require('child_process');
const os = require('os');

const program = new Command();

const FREEGLUT_VERSION = '3.8.0';
const DOWNLOAD_URL = `https://github.com/freeglut/freeglut/releases/download/v${FREEGLUT_VERSION}/freeglut-${FREEGLUT_VERSION}.tar.gz`;

program
    .name('glut')
    .description('CLI tool for FreeGLUT project management')
    .version('1.0.0');

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
    .command('create [project-name]')
    .description('Create a new FreeGLUT project from template')
    .action(async (projectName = 'Project') => {
        const root = path.resolve(projectName);
        const appName = path.basename(root);

        if (fs.existsSync(root)) {
            console.log(chalk.red(`Directory ${projectName} already exists.`));
            process.exit(1);
        }

        console.log(chalk.cyan(`Creating a new FreeGLUT app in ${chalk.bold(root)}...`));

        await fs.ensureDir(root);

        const templateDir = path.join(__dirname, 'template');
        if (!fs.existsSync(templateDir)) {
            console.log(chalk.red('Template directory not found. Please ensure the CLI is installed correctly.'));
            process.exit(1);
        }

        // Copy template files
        await fs.copy(templateDir, root);

        // Customize project files if needed (e.g., replacing "ProjectName" in README)
        // For now, it's a simple copy.

        console.log(chalk.green('\nSuccess!'));
        console.log(`Created ${appName} at ${root}`);
        console.log('\nTo get started:');
        console.log(chalk.cyan('    code .'));
        console.log(chalk.gray('    (Then press F5 to build and run)'));
    });

async function setupWindows() {
    const targetDir = 'C:\\freeglut';
    console.log(chalk.yellow(`Target directory: ${targetDir}`));

    try {
        if (!fs.existsSync(targetDir)) {
            await fs.ensureDir(targetDir);
        }

        // Note: For Windows, downloading the source might not be enough for a "ready to use" setup 
        // if they don't have a compiler. But the user asked for download and unzip.
        // We'll download the source for now as requested.
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
