package om;

import js.Browser.document;
import js.html.DOMParser;
import js.html.Element;
import js.html.StyleElement;
import js.html.SupportedType;

using StringTools;

typedef Data = {

	/** Application Background. **/
	var background : String;

	/** Foreground, high-contrast. **/
	var f_high : String;
	
	/** Foreground, medium-contrast. **/
	var f_med : String;
	
	/** Foreground, low-contrast. **/
	var f_low : String;
	
	/** Foreground, for modals and overlays. **/
	var f_inv : String;
	
	/** Background, high-contrast. **/
	var b_high : String;
	
	/** Background, medium-contrast. **/
	var b_med : String;
	
	/** Background, low-contrast. **/
	var b_low : String;
	
	/** Background, for modals and overlays. **/
	var b_inv : String;
}

/**
	Each foreground color should be readable on every background color, with the exception of the inv types, which are designed to be used in warnings or modals and should only overlap each other.
	A variable's contrast should be seen as an offset to the global background color, so instance, f_high represents a high contrast color against the global background, and so does b_high, representing a highly contrasted color against the global background.
	
	You can test your themes online with the Theme Benchmark: https://hundredrabbits.github.io/Themes/
*/
class Theme {

	public var data(default,null) : Data;

	var element : StyleElement;

	public function new() {
		element = document.createStyleElement();
		element.type = 'text/css';
	}

	public function install( ?host : Element ) {
		if( host == null ) host = document.head;
		host.appendChild( element );
	}

	public function uninstall() {
		element.remove();
	}

	public function set( data : Data, ?selector : String ) {
		this.data = data;
		element.innerHTML = toCSS( selector, data );
	}

	/*
	public static function apply( theme : Data, name = 'theme' ) {
		var e = document.head.querySelector( 'style[name="$name"]' );
		if( e == null ) {
			e = document.createStyleElement();
			e.classList.add( 'theme' );
			document.head.appendChild( e );
		}
		e.innerHTML = toCSS( theme );
	}

	public static inline function applySVG( str : String ) {
		apply( parseSVG( str ) );
	}
	*/

	public static function toCSS( selector = ':root', theme : Data) : String {
		var s = '$selector{';
		for( f in Reflect.fields( theme ) )
			s += '--$f:${Reflect.field( theme, f )};';
		return '$s}';
	}
		
	/*
	public static function toSVG( theme : Data ) : Xml {
		var xml = Xml.createElement( 'svg' );
		xml.set( 'xmlns', 'http://www.w3.org/2000/svg' );
		xml.set( 'baseProfile', 'full' );
		xml.set( 'version', '1.1' );
		xml.set( 'width', '96px' );
		xml.set( 'height', '66px' );
		function addElement( name : String, attributes : Map<String,String>) {
		}
		addElement( 'rect', [ 'id'=>'f_' 'width'=>'96', 'height'=>'64' ] );
		function addCircleElement( id : String, x : Int, y : Int ) {
		}
		return xml;
	}
	*/

	public static function parseSVG( str : String ) : Data {
		var svg = new DOMParser().parseFromString( str, SupportedType.TEXT_XML );
		function get( id : String )
			return svg.getElementById( id ).getAttribute( 'fill' );
		return {
			background : get( 'background' ),
			f_high : get( 'f_high' ),
			f_med : get( 'f_med' ),
			f_low : get( 'f_low' ),
			f_inv : get( 'f_inv' ),
			b_high : get( 'b_high' ),
			b_med : get( 'b_med' ),
			b_low : get( 'b_low' ),
			b_inv : get( 'b_inv' ),
		};
	}
	
}
