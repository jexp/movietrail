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

	onShow: function(feature) { },

	animation: null,

	index: 0,

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
	 * Method: start
	 * Activates the control, the animation starts.
	 */
	start: function() {
		this.stop();
		this.play();
	},

	pause: function() {
		clearInterval(this.animation);
	},

	stop: function() {
		this.index = 0;
		this.layer.removeAllFeatures();
	},

	play: function() {
		var that = this;
		this.animation = setInterval(function() {
			that.onShow(that.features[that.index]);
			that.layer.addFeatures(that.features[that.index]);
			if (!that.features[that.index+1]) {
				if (that.loop) {
					that.stop();
				} else {
					clearInterval(that.animation);
				}
			}
			that.index++;
		}, this.delay);
	},

	jumpTo: function(index) {
		this.stop();
		for (var i = 0; i < index; i++) {
			this.layer.addFeatures(this.features[i]);
		}
		this.index = index;
	},

	CLASS_NAME: "OpenLayers.Control.Animation"
});
