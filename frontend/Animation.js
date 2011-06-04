/**
 * @requires OpenLayers/Control.js
 */

/**
 * Class: OpenLayers.Control.Animation
 * The Animation control takes a vector layer and displays its features
 * one after another.
 *
 * Inherits from:
 *  - <OpenLayers.Control>
 */
OpenLayers.Control.Animation = OpenLayers.Class(OpenLayers.Control, {

	/**
	 * Property: layer
	 * {<OpenLayers.Layer.Vector>} The vector layer that will be animated.
	 */
	layer: null,

	/**
	 * Property: features
	 * {Array(<OpenLayers.Feature.Vector>)} the features of the selected layer.
	 */
	features: null,

	/**
	 * APIProperty: loop
	 * {Boolean} If true the animation will run in a loop.
	 * If false the animation will run only once.
	 */
	loop: false,

	/**
	 * APIProperty: delay
	 * {Integer} The delay between displaying of features in milliseconds.
	 */
	delay: 1,

	/**
	 * Constructor: OpenLayers.Control.Animation
	 * Create a new control to animate a vector layer.
	 *
	 * Parameters:
	 * layer - {<OpenLayers.Layer.Vector>} The vector that will be animated.
	 * optiond - {Object}
	 */
	initialize: function (layer, options) {
		OpenLayers.Control.prototype.initialize.apply(this, [options]);
		if (layer) {
			this.layer = layer;
			this.features = this.layer.features;
		}
	},

	/**
	 * Method: activate
	 * Activates the control, the animation starts.
	 */
	activate: function() {
		var i = 0, that = this;
		this.layer.removeAllFeatures();
		var animation = setInterval(function() {
			that.layer.addFeatures(that.features[i]);
			if (!that.features[i+1]) {
				if (that.loop) {
					i = 0;
					that.layer.removeAllFeatures();
				} else {
					clearInterval(animation);
				}
			}
			i++;
		}, this.speed);
	},

	CLASS_NAME: "OpenLayers.Control.Animation"
});
