module.exports = {
  dependency: {
    platforms: {
      android: {
        sourceDir: 'juggleim-rnsdk/android',
        packageImportPath: 'import com.juggleim.JuggleIMPackage;',
        packageInstance: 'new JuggleIMPackage()',
      },
    },
  },
};
