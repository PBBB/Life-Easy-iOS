ExtensionPreprocessingJS = {
    run : function(arguments) {
        arguments.completionFunction({"head":document.head.innerHTML, "body":document.body.innerHTML, "title":document.title});
    },

    finalize : function(arguments) {
//        document.body.style.backgroundColor = 'red';
    }
};