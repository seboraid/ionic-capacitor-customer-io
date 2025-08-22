// Simple test to verify plugin structure
const fs = require('fs');
const path = require('path');

console.log('Testing Ionic Customer.io Plugin Structure...\n');

// Check if all required files exist
const requiredFiles = [
  'package.json',
  'tsconfig.json',
  'rollup.config.js',
  'src/index.ts',
  'src/definitions.ts',
  'src/web.ts',
  'android/build.gradle',
  'android/src/main/java/com/yourcompany/ioniccustomerio/CustomerIoPlugin.java',
  'ios/Plugin/CustomerIoPlugin.swift',
  'ios/Plugin/CustomerIoPlugin.m',
  'IonicCustomerIo.podspec',
  'README.md',
  'dist/esm/index.js',
  'dist/plugin.js',
  'dist/plugin.cjs.js'
];

let allFilesExist = true;

requiredFiles.forEach(file => {
  const filePath = path.join(__dirname, file);
  if (fs.existsSync(filePath)) {
    console.log(`✅ ${file}`);
  } else {
    console.log(`❌ ${file} - MISSING`);
    allFilesExist = false;
  }
});

if (allFilesExist) {
  console.log('\n🎉 All required files are present!');
  
  // Check TypeScript definitions
  const definitionsPath = path.join(__dirname, 'dist/esm/definitions.d.ts');
  if (fs.existsSync(definitionsPath)) {
    const definitions = fs.readFileSync(definitionsPath, 'utf8');
    if (definitions.includes('CustomerIoPlugin')) {
      console.log('✅ TypeScript definitions are valid');
    } else {
      console.log('❌ TypeScript definitions missing CustomerIoPlugin interface');
    }
  }
  
  // Check package.json
  const packageJsonPath = path.join(__dirname, 'package.json');
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
  
  if (packageJson.main && packageJson.module && packageJson.types) {
    console.log('✅ Package.json exports are configured');
  } else {
    console.log('❌ Package.json exports are not properly configured');
  }
  
  console.log('\n📦 Plugin Structure Validation Complete!');
  console.log('\nNext Steps:');
  console.log('1. Update package.json with your repository details');
  console.log('2. Replace "your-site-id" and "your-api-key" with actual Customer.io credentials');
  console.log('3. Update the package name in Android manifest and Java files');
  console.log('4. Test in an actual Ionic/Capacitor project');
  console.log('5. Publish to npm registry');
  
} else {
  console.log('\n❌ Plugin structure is incomplete. Please ensure all files are created.');
  process.exit(1);
}