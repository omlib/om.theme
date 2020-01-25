package om;

import js.Browser.document;
import js.html.DOMParser;
import js.html.Element;
import js.html.StyleElement;
import js.html.SupportedType;

using StringTools;

typedef Data = {
	var background : String;
	var f_high : String;
	var f_med : String;
	var f_low : String;
	var f_inv : String;
	var b_high : String;
	var b_med : String;
	var b_low : String;
	var b_inv : String;
}

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
