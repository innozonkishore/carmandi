/*********************************************\
  Extensions for standard Prototype
\*********************************************/

//////////////////
// Include the ability to react to the loading of the actual DOM tree, BEFORE the loading
// of all embedded content (eg. images, objects, etc.)
// Assembled from a non-Prototype solution first built by Dean Edwards, Matthias Miller, and John Resig
// originally found at http://dean.edwards.name/weblog/2006/06/again/?full#comments
Object.extend( Event, {
	DOMReadyObserved: false,
	DOMReadyObservers: false,
	DOMReadyBrowserDevice: false,
	
	observeDOMReady: function ( observer ) {
		// If the DOM is *already* ready, run the observer immediately.
		if (Event.DOMReadyObserved) {
			observer();
		} else {
	    	if ( ! Event.DOMReadyObservers ) { Event.DOMReadyObservers = new Array(); };
			Event.DOMReadyObservers.push( observer );
		};
	},
	
	runDOMReady: function () {
		// Only run these ONCE.
		if (Event.DOMReadyObserved) { return; };
		Event.DOMReadyObserved = true;

		if ( ! Event.DOMReadyObservers ) { Event.DOMReadyObservers = new Array(); };
		for(var i=0; i<Event.DOMReadyObservers.length; i++) {
			Event.DOMReadyObservers[i]();
		}
		Event.DOMReadyObservers.clear();
	}
});

do {
	/* All browsers - also takes care of this happening too fast */
	Event.observe(window, 'load', Event.runDOMReady );

	/* Internet Explorer */
	/*@cc_on @*/
	/*@if (@_win32)
		if ( window.location.protocol != "https:" ) {
			document.write("<sc" + "ript id='__ie_observeDOMReady' defer='defer' src='javascript:void(0);'><\/sc" + "ript>");
			Event.DOMReadyBrowserDevice = document.getElementById("__ie_observeDOMReady");
			Event.DOMReadyBrowserDevice.onreadystatechange = function() {
				if (this.readyState == "complete") {
					Event.runDOMReady(); // call the onload handler
				}
			};
			break;
		}
	/*@end @*/
	
	/* Safari/Konqueror */
	/* WebKit must be tested for before DOM2 standard because WebKit supports document.addEventListener but NOT the 
	   DOMContentLoaded event. */
	if (/WebKit/i.test(navigator.userAgent)) { 
		Event.DOMReadyBrowserDevice = setInterval(function() {
			if (/loaded|complete/.test(document.readyState)) {
				clearInterval(Event.DOMReadyBrowserDevice);
				Event.runDOMReady(); 
			}
		}, 10);
		break;
	}
	
	/* Mozilla/Opera9/DOM2 Compliant browsers */
	if (document.addEventListener) {
		document.addEventListener("DOMContentLoaded", Event.runDOMReady, false);
		break;
	}

} while(0);

//////// End of DomContentLoaded observer

Object.print_r = function ( obj, ind ) {
	ind = ind || "";
	if ( ind.length > 10 ) { return '<object>...'; };
	if (obj == null) { return '<null>'; };
	if (typeof(obj) == 'undefined' ) { return '<undefined>'; }; 
	if (typeof(obj) == 'function' ) { return '<function>'; }; 
	if (typeof(obj) == 'string' ) { return '"' + obj + '"'; }; 
	if ( !(isNaN(parseFloat(obj))) ) { return '' + obj; }
	else {
		res = "{\n";
		for( k in obj ) {
			res += ind + "   " + k + ": " + Object.print_r( obj[k], ind + "   " ) + ",\n";
		}
		res += ind + "}";
	};
	return res;
}

Object.print_r1 = function ( obj, stop ) {
	if (obj == null) { return '<null>'; };
	if (typeof(obj) == 'undefined' ) { return '<undefined>'; }; 
	if (typeof(obj) == 'function' ) { return '<function>'; }; 
	if (typeof(obj) == 'string' ) { return '"' + obj + '"'; }; 
	if ( !(isNaN(parseFloat(obj))) ) { return '' + obj; }
	else {
		if (stop) {
			return "<object>";
		} else {
			res = "{\n";
			for( k in obj ) {
				res += "   " + k + ": " + Object.print_r1( obj[k], true ) + ",\n";
			}
			res += "}";
		}
	};
	return res;
}

Form.Element.decimalpoint = (1.11).toLocaleString().charAt(1);

// Upgrades for the Form.Element object methods
Object.extend( Form.Element.Methods, {

	addSelectOptions: function(element, selectoptionshash, options) {
		element = $(element);
		if (element.nodeName.toUpperCase() != "SELECT") {
			// Can't do this except to SELECTs.
			return element;
		}
		
		options = Object.extend({ selectedvalue:null }, options);
		selectoptionshash = $H(selectoptionshash);
		var selectedvalue = options.selectedvalue;
		
		var option;
		selectoptionshash.each( function( pair ) {
			pair.value = pair.value.toString();
			pair.key = pair.key.toString();
			if ( pair.value.length < 1 ) { pair.value = pair.key; }
			option = document.createElement('option');
			option.innerHTML = pair.value;
			option.value = pair.key;
			option.selected = (selectedvalue === pair.key);
			element.appendChild( option );
		});
		
		return element;
	},
	
	loadSelectOptions: function( element, url, options ) {
		element = $(element);
		options = Object.extend({ clear:false, selectedvalue:null, prependoptions:null, appendoptions:null }, options);
		if (element.nodeName.toUpperCase() != "SELECT") {
			// Can't do this except to SELECTs.
			return element;
		}
		if ( options.clear ) {
			element.truncate();
		}

		var ajax = new Ajax.Request(url, {
			method: 'get',
			onSuccess: function(transport) {
				var selectoptionshash = null;
				try {
					eval( "selectoptionshash = " + transport.responseText);
				} catch (e) {
					alert( "Could not read the select list: " + e.message );
				}
				if ( options.prependoptions ) { element.addSelectOptions( options.prependoptions, { selectedvalue: options.selectedvalue} ) };
				element.addSelectOptions( selectoptionshash, { selectedvalue: options.selectedvalue} );
				if ( options.appendoptions ) { element.addSelectOptions( options.appendoptions, { selectedvalue: options.selectedvalue} ) };
			},
			onFailure: function(transport) {
				alert("Could not load the select list - the response was " + transport.status + " " + transport.statusText );
			}
		});	
	},
	
	getValueFixed: function (element, decimalplaces) {
		decimalplaces = (decimalplaces==null) ? 2 : decimalplaces;
		return parseFloat( parseFloat( '0' + element.value.replace(/[^0-9.]/g,'')).toFixed(decimalplaces) );
	},

	getValuePercent: function (element, smallestpercent, decimalplaces) {
		smallestpercent = smallestpercent || 0;
		decimalplaces = (decimalplaces==null) ? 2 : decimalplaces;
		var p = parseFloat( '0' + element.value.replace(/[^0-9.]/g,''));
		if (Math.abs(p) < smallestpercent) { p *= 100.0; }
		return parseFloat( p.toFixed(decimalplaces) );
	},
	
	formatValueAsMoney: function (element, currencysymbol) {
		currencysymbol = (currencysymbol || "$").toString();
		element.value = currencysymbol + (element.getValueFixed(2) ).toLocaleString();
		
		var decimalat = element.value.indexOf(decimalpoint);
		if ( decimalat < 0 ) {
			element.value += decimalpoint + "00";
		} else if (decimalat > (element.value.length-3) ) {
			element.value += "0"
		}
	},
	
	formatValueAsPercent: function (element, smallestpercent, decimalplaces) {
		element.value = element.getValuePercent(smallestpercent, decimalplaces).toFixed(decimalplaces) + " %";
	}

});

// Upgrades for the Element global object itself - static methods and properties
Object.extend( Element, {
});



// Upgrades for the standard Element object
Element.addMethods({
	   
	// <domelement>.eachTag( string <tagname>, function <iteratorfunction> )
	// An iterator that applies iteratorfunction to each of the tags in
	// domelement with the given tagname. If tagname is "*", operates on all tags.
	eachTag: function(element, tag, iterator) {
		element = $(element);
		element.cleanWhitespace();
		$A(element.getElementsByTagName(tag)).each(iterator);
		return element;
	},

	// <domelement>.firstTag( string <tagname> )
	// Returns the first tag of given type found in <domelement>, or null
	// if not found.
	firstTag: function(element, tag) {
		element = $(element);
		element.cleanWhitespace();
		var taglist = $A(element.getElementsByTagName(tag));
		if ( taglist.length == 0 ) {
			return null;
		} else { 
			return taglist[0];
		};
	},

	// <domelement>.firstTagWithClass( string <tagname>, string <classname> )
	// Returns the first tag of given type found in <domelement> which has the
	// given class name, or null if not found.
	firstTagWithClass: function( element, tag, classname ) {
		element = $(element);
		element.cleanWhitespace();
		var taglist = $A(element.getElementsByTagName(tag));
		
		for (var i=0; i<taglist.length; i++ ) {
			if ( Element.classNames(taglist[i]).include(classname) ) {
				return taglist[i];
			};
		};
		
		return null;
	},

	// <domelement>.absoluteLeft()
	// Returns the absolute left position of the element relative to the document
	// at large (in pixels), regardless of how the element is positioned.
	absoluteLeft: function( element ) {
		return Position.cumulativeOffset($(element))[0];
	},
 
	// <domelement>.absoluteTop()
	// Returns the absolute top position of the element relative to the document
	// at large (in pixels), regardless of how the element is positioned.
 	absoluteTop: function( element ) {
		return Position.cumulativeOffset($(element))[1];
	},

	// <domelement>.absolutePosition()
	// Returns an object with the absolute top and left position of the element relative
	// to the document at large (in pixels), regardless of how the element is positioned.
	// Return takes the form { left:<leftvalue>, top:<topvalue> }
 	absolutePosition: function( element ) {
		var pos = Position.cumulativeOffset($(element));
		return { left: pos[0], top: pos[1] };
	},

	// <domelement>.moveToElement( <targetelement>, <offsetx>, <offsety> )
	// Marks the <domelement> as positioned absolutely and moves it to the absolute
	// location of <targetelement>.
	// Options include:
	// offsetx (default 0), horizontal offset from initial position in pixels
	// offsety (default 0), horizontal offset from initial position in pixels
	// halign  (default "left"), horizontal alignment of the element relative to the target element, "left"/"center"/"right"/"before"/"after"
	// valign  (default "top"), vertical alignment of the element relative to the target element, "top"/"center"/"bottom"/"above"/"below"
	moveToElement: function( element, targetelement, optionshash ) {
		optionshash = $H( { offsetx:0, offsety:0, halign:'left', valign:'top' } ).merge( optionshash );
		element = $( element );
		targetelement = $( targetelement );
			
		var leftcalc = parseInt(optionshash['offsetx']);
		var topcalc = parseInt(optionshash['offsety']);
		
		switch( optionshash['halign'] ) {
			case 'center':
				leftcalc = leftcalc + (targetelement.getWidth()/2) - (element.getWidth() / 2);
				break;
			case 'right':
				leftcalc = leftcalc + targetelement.getWidth() - element.getWidth();
				break;
			case 'before':
				leftcalc = leftcalc - element.getWidth();
				break;
			case 'after':
				leftcalc = leftcalc + targetelement.getWidth();
				break;
		}

		switch( optionshash['valign'] ) {
			case 'center':
				topcalc = topcalc + (targetelement.getHeight()/2) - (element.getHeight() / 2);
				break;
			case 'bottom':
				topcalc = topcalc + targetelement.getHeight() - element.getHeight();
				break;
			case 'above':
				topcalc = topcalc  - element.getHeight();
				break;
			case 'below':
				topcalc = topcalc + targetelement.getHeight();
				break;
		}

		Position.clone( targetelement, element, { setLeft:true, setTop:true, setWidth:false, setHeight:false, offsetLeft: leftcalc, offsetTop: topcalc } );
		return element;
	},

	// <domelement>.appendContent( <html> )
	// Inserts the given HTML appended to the content of <domelement> and return it
	appendContent: function( element, html ) {
		element = $(element);
		element.innerHTML = element.innerHTML + html.toString();
		return element;
	},

	// <domelement>.truncate()
	// Delete all of the element's content and return it.
	truncate: function( element ) {
		element = $(element);
		var children = $A(element.childNodes).clone();
		for( var i=0; i< children.length; i++ ) { element.removeChild(children[i]) }
		return element;
	}
});


// New feature for Ajax.Updater - if the option "stripoutertags" is true, then
// the response text will be searched for enclosing <body> tags, and 
// they and anything outside them will be removed. Allows compliant
// HTML pages to be embedded in compliant HTML pages without breaking the 
// many compliance rules about duplicate heads and bodies and illegal tags.
// This pretty much requires remaking the Updater. Includes an AJAX utility
// function to perform the string manipulation on the response itself.

Object.extend(Ajax, {
  stripOuterTags: function( response ) {
	var bodycontentbegin = response.indexOf(">", response.search( /[.\n]*<body[^>]*>/im )) + 1 ;
	var bodycontentlength = response.search( /[.]*<\/body[^>]*>/im ) - bodycontentbegin;
	return response.substr( bodycontentbegin, bodycontentlength );
  }	
});

Object.extend(Ajax.Updater.prototype, {
  initialize: function(container, url, options) {
    this.container = {
      success: (container.success || container),
      failure: (container.failure || (container.success ? null : container))
    }

    this.transport = Ajax.getTransport();
    this.setOptions(options);
	this.responseText = null;

    var onComplete = this.options.onComplete || Prototype.emptyFunction;
    this.options.onComplete = (function(transport, param) {
	  if ( this.options.stripoutertags ) { this.stripOuterTags(); };
      this.updateContent();
      onComplete(transport, param);
    }).bind(this);

    this.request(url);
  },
  
  stripOuterTags: function( ) {
	this.responseText = Ajax.stripOuterTags( this.responseText || this.transport.responseText );
  },

  updateContent: function() {
    var receiver = this.container[this.success() ? 'success' : 'failure'];
    var response = this.responseText || this.transport.responseText;

    if (!this.options.evalScripts) response = response.stripScripts();

    if (receiver = $(receiver)) {
      if (this.options.insertion)
        new this.options.insertion(receiver, response);
      else
        receiver.update(response);
    }

    if (this.success()) {
      if (this.onComplete)
        setTimeout(this.onComplete.bind(this), 10);
    }
  }
  
});

// Expand Position.Clone - adding the height and width offsets
Position.clone = function(source, target) {
    var options = Object.extend({
      setLeft:    true,
      setTop:     true,
      setWidth:   true,
      setHeight:  true,
      offsetTop:  0,
      offsetLeft: 0,
      offsetWidth:  0,
      offsetHeight: 0
    }, arguments[2] || {})

    // find page position of source
    source = $(source);
    var p = Position.page(source);

    // find coordinate system to use
    target = $(target);
    var delta = [0, 0];
    var parent = null;
    // delta [0,0] will do fine with position: fixed elements,
    // position:absolute needs offsetParent deltas
    if (Element.getStyle(target,'position') == 'absolute') {
      parent = Position.offsetParent(target);
      delta = Position.page(parent);
    }

    // correct by body offsets (fixes Safari)
    if (parent == document.body) {
      delta[0] -= document.body.offsetLeft;
      delta[1] -= document.body.offsetTop;
    }

    // set position
    if(options.setLeft)   target.style.left  = (p[0] - delta[0] + options.offsetLeft) + 'px';
    if(options.setTop)    target.style.top   = (p[1] - delta[1] + options.offsetTop) + 'px';
    if(options.setWidth)  target.style.width = (0 + source.offsetWidth + options.offsetWidth) + 'px';
    if(options.setHeight) target.style.height = (0 + source.offsetHeight + options.offsetHeight) + 'px';
  };
 
/*******************************************************************\
   Completely new object for creating and operating on Stylesheets
\*******************************************************************/

var StyleSheets = Class.create();


Object.extend( StyleSheets, {
	// Static methods/properties
	extend: function(ss) {
		if ( ss._extended ) { return ss; };
		
		if ( ss.rules ) {
			Object.extend( ss, StyleSheets.IE );
		} else {
			Object.extend( ss, StyleSheets.W3C );
		};
		Object.extend( ss, StyleSheets.Base );
		
		ss._extended = true;
		return ss;
	}
	
});


StyleSheets.Base = {
	// Instance methods/properties
	addCSS: function( CSS ) {
		if (typeof CSS != 'string') { return; }
		
		var stanzalist = CSS.split("}");
		var sheet = this;
		stanzalist.each( function(entry) {
			var entrysplit = entry.replace(/\n/g, " ").split("{");
			var rule = entrysplit[1];
			var selectors = entrysplit[0].split(",");
			for( var i=0; i<selectors.length; i++ ) {
				sheet.addRule( selectors[i], rule );
			}
		});
	}
};

StyleSheets.IE = {
	// Instance methods/properties
};

StyleSheets.W3C = {
	// Instance methods/properties
	addRule: function( selector, rule ) {
		this.insertRule( selector + " { " + rule + " }" );
	}
};

/******************************************************************\
   Completely new object for automagically rewriting DOM segments
\******************************************************************/

var Rewriter = Class.create();

Rewriter.prototype = {
	// Instance methods/properties
	initialize: function ( tagname, classname, iterator ) {
		if ( classname ) {
			if ( classname.any ) {
				var classselector = function(e) { return (e.className)?( classname.any( function(cn) { if(!cn){ return false; }; var EcN = Element.classNames(e); return EcN ? EcN.include( cn ) : false; } ) ) : false; };
			} else {
				var classselector = function(e) { return (Element.classNames(e).include( classname )); };
			}
		} else {
			var classselector = function (e) { return true; };
		}

		if ( tagname ) {
			var elementselector = function() { return $A(document.body.getElementsByTagName(tagname)); };
		} else {
			var elementselector = function() { return $A(document.body.getElementsByTagName('*')); };
		}
		
		Event.observeDOMReady( function() { 
			elementselector().findAll( classselector ).each( iterator );
		} );
	}
};	



