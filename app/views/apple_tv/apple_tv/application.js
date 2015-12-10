//# sourceURL=application.js

/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This is the entry point to the application and handles the initial loading of required JavaScript files.
*/

var resourceLoader;

/**
 * @description The onLaunch callback is invoked after the application JavaScript 
 * has been parsed into a JavaScript context. The handler is passed an object 
 * that contains options passed in for launch. These options are defined in the
 * swift or objective-c client code. Options can be used to communicate to
 * your JavaScript code that data and as well as state information, like if the 
 * the app is being launched in the background.
 *
 * The location attribute is automatically added to the object and represents 
 * the URL that was used to retrieve the application JavaScript.
 */
App.onLaunch = function(options) {
    var javascriptFiles = [
        `${options.BASEURL}js/ResourceLoader.js`,
        `${options.BASEURL}js/Presenter.js`
    ];

    /**
     * evaluateScripts is responsible for loading the JavaScript files neccessary
     * for you app to run. It can be used at any time in your apps lifecycle.
     * 
     * @param - Array of JavaScript URLs  
     * @param - Function called when the scripts have been evaluated. A boolean is
     * passed that indicates if the scripts were evaluated successfully.
     */
    evaluateScripts(javascriptFiles, function(success) {
        if (success) {
            resourceLoader = new ResourceLoader(options.BASEURL);

            var index = resourceLoader.loadResource(`${options.BASEURL}templates/Index.xml.js`,
                function(resource) {
                    var doc = Presenter.makeDocument(resource);
                    doc.addEventListener("select", Presenter.load.bind(Presenter));
                    navigationDocument.pushDocument(doc);
                });
        } else {
            /*
            Be sure to handle error cases in your code. You should present a readable, and friendly
            error message to the user in an alert dialog.

            See alertDialog.xml.js template for details.
            */
            var alert = createAlert("Evaluate Scripts Error", "There was an error attempting to evaluate the external JavaScript files.\n\n Please check your network connection and try again later.");
            navigationDocument.presentModal(alert);

            throw ("Playback Example: unable to evaluate scripts.");
        }
    });
}


/**
 * This convenience funnction returns an alert template, which can be used to present errors to the user.
 */
var createAlert = function(title, description) {

    var alertString = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
          <alertTemplate>
            <title>${title}</title>
            <description>${description}</description>
          </alertTemplate>
        </document>`

    var parser = new DOMParser();

    var alertDoc = parser.parseFromString(alertString, "application/xml");

    return alertDoc
}

/**
 * @description - an example implementation of search that reacts to the 
 * keyboard onTextChange (see Presenter.js) to filter the lockup items based on the search text
 * @param {Document} doc - active xml document 
 * @param {String} searchText - current text value of keyboard search input
 */
var buildResults = function(doc, searchText) {

    //simple filter and helper function
    var regExp = new RegExp(searchText, "i");
    var matchesText = function(value) {
        return regExp.test(value);
    }

    //sample data for search example
    var movies = {
        "The Puffin": 1,
        "Lola and Max": 2,
        "Road to Firenze": 3,
        "Three Developers and a Baby": 4,
        "Santa Cruz Surf": 5,
        "Cinque Terre": 6,
        "Creatures of the Rainforest": 7
    };
    var titles = Object.keys(movies);

    //Create parser and new input element
    var domImplementation = doc.implementation;
    var lsParser = domImplementation.createLSParser(1, null);
    var lsInput = domImplementation.createLSInput();

    //set default template fragment to display no results
    lsInput.stringData = `<list>
      <section>
        <header>
          <title>No Results</title>
        </header>
      </section>
    </list>`;

    //Apply filter to titles array using matchesText helper function
    titles = (searchText) ? titles.filter(matchesText) : titles;

    //overwrite stringData for new input element if search results exist by dynamically constructing shelf template fragment
    if (titles.length > 0) {
        lsInput.stringData = `<shelf><header><title>Results</title></header><section id="Results">`;
        for (var i = 0; i < titles.length; i++) {
            lsInput.stringData += `<lockup>
          <img src="${this.resourceLoader.BASEURL}resources/images/movies/movie_${movies[titles[i]]}.lcr" width="350" height="520" />
          <title>${titles[i]}</title>
        </lockup>`;
        }
        lsInput.stringData += `</section></shelf>`;
    }

    //add the new input element to the document by providing the newly created input, the context, 
    //and the operator integer flag (1 to append as child, 2 to overwrite existing children)
    lsParser.parseWithContext(lsInput, doc.getElementsByTagName("collectionList").item(0), 2);
}
