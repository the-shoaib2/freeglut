#!/usr/bin/env node

const { Command } = require('commander');
const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');
const prompts = require('prompts');
const fetch = require('node-fetch');
const tar = require('tar');
const { execSync } = require('child_process');

const program = new Command();

async function init() {
    program
        .version('1.0.0')
        .argument('[project-name]', 'name of the project')
        .action(async (projectName) => {
            let targetDir = projectName;

            if (!targetDir) {
                const response = await prompts({
                    type: 'text',
                    name: 'name',
                    message: 'How do you want to name your app?',
                    initial: 'Project'
                });
                targetDir = response.name;
            }

            if (!targetDir) {
                console.log(chalk.red('Please specify a project name.'));
                process.exit(1);
            }

            const root = path.resolve(targetDir);
            const appName = path.basename(root);

            if (fs.existsSync(root)) {
                console.log(chalk.red(`Directory ${targetDir} already exists.`));
                process.exit(1);
            }

            console.log(chalk.cyan(`Creating a new FreeGLUT app in ${chalk.bold(root)}...`));

            await fs.ensureDir(root);

            const templateDir = path.join(__dirname, 'template');

            // Copy template files
            await fs.copy(templateDir, root);

            // Setup FreeGLUT if needed
            await setupFreeGLUT(root);

            console.log(chalk.green('\nSuccess!'));
            console.log(`Created ${appName} at ${root}`);
            console.log('\nInside that directory, you can run several commands:');
            console.log(chalk.cyan('\n  On macOS/Linux:'));
            console.log(chalk.yellow('    ./build.sh'));
            console.log(chalk.cyan('\n  On Windows:'));
            console.log(chalk.yellow('    .\\build.bat'));
            console.log('\nWe suggest that you begin by typing:');
            console.log(chalk.cyan(`  cd ${targetDir}`));
            console.log(chalk.cyan('  code .'));
        });

    program.parse(process.argv);
}

async function setupFreeGLUT(projectRoot) {
    const os = process.platform;
    console.log(chalk.yellow('Setting up dependencies...'));

    if (os === 'darwin') {
        // On macOS, we can check if freeglut is installed via brew, 
        // but the template uses system frameworks which is fine for basic GLUT.
        // However, the user mentioned 3.8.0 specifically.
        console.log(chalk.gray('macOS detected. Using system frameworks or Homebrew if available.'));
    } else if (os === 'win32') {
        // On Windows, downloading the library might be useful.
        console.log(chalk.gray('Windows detected. Checking for FreeGLUT...'));
        // For Windows, we might want to download precompiled binaries if available, 
        // but the link provided is for source. Building from source on Windows is hard via CLI.
        // Usually, users expect the .lib and .dll.
    } else {
        console.log(chalk.gray('Linux detected. Ensure freeglut3-dev is installed.'));
    }

    // If the user explicitly wants to download the source 3.8.0:
    const downloadUrl = 'https://github.com/freeglut/freeglut/releases/download/v3.8.0/freeglut-3.8.0.tar.gz';
    const depDir = path.join(projectRoot, 'deps');

    try {
        const response = await fetch(downloadUrl);
        if (!response.ok) throw new Error(`Failed to fetch ${downloadUrl}: ${response.statusText}`);

        await fs.ensureDir(depDir);
        const tarPath = path.join(depDir, 'freeglut-3.8.0.tar.gz');
        const fileStream = fs.createWriteStream(tarPath);

        console.log(chalk.yellow('Downloading FreeGLUT 3.8.0 source...'));
        await new Promise((resolve, reject) => {
            response.body.pipe(fileStream);
            response.body.on('error', reject);
            fileStream.on('finish', resolve);
        });

        console.log(chalk.yellow('Extracting FreeGLUT 3.8.0...'));
        await tar.x({
            file: tarPath,
            C: depDir
        });

        // Remove the tarball after extraction
        await fs.remove(tarPath);

    } catch (err) {
        console.log(chalk.red(`Could not download FreeGLUT source: ${err.message}`));
        console.log(chalk.yellow('Please install FreeGLUT manually on your system.'));
    }
}

init().catch((err) => {
    console.error(err);
    process.exit(1);
});
