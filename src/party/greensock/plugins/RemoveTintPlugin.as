/**
 * party.greensockCparty.greensockTIONSCRIPT VERSION: 3.0 
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
package party.greensock.plugins {
	import party.greensock.plugins.TintPlugin;
/**
 * Removes the tint of a DisplayObject over time. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import party.greensock.TweenLite; <br />
 * 		import party.greensock.plugins.TweenPlugin; <br />
 * 		import party.greensock.plugins.RemoveTintPlugin; <br />
 * 		TweenPlugin.activate([RemoveTintPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {removeTint:true}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class RemoveTintPlugin extends TintPlugin {
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function RemoveTintPlugin() {
			super();
			this.propName = "removeTint";
		}

	}
}