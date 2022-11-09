/**
 * @license Copyright (c) 2003-2016, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
		config.width = '297mm';
        config.height = '210mm';
		config.extraPlugins = 'filebrowser';
		config.extraPlugins = 'texttransform';

		config.backgroundColor = '#ffffff';
		config.filebrowserBrowseUrl = '../styles/fileman/index.html';
		config.filebrowserImageBrowseUrl = '../styles/fileman/index.html';
};
