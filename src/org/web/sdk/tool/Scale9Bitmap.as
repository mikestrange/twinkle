package org.web.sdk.tool
{
    //-----------------------------------------------------------------------------
    //  Imports
    //-----------------------------------------------------------------------------
    import flash.display.BitmapData;
	import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    /**
     * Scale9Bitmap by Joonas Mankki.
     * Last updated 29.9.2009
     *
     * Scale9Bitmap allows you to scale a bitmap image the same way as the Actionscript native
     * scale9grid feature allows scaling vector graphics. In short, when you scale a Scale9Bitmap
     * instance, the corners of the image are not stretched at all, the borders are stretched
     * along their own axis, and the middle part of the image is stretched as normal.
     *
     * There is one difference in the behavior of Scale9Bitmap when compared to scale9grid of a
     * vector object. You are allowed to specify only the top and left offset of the grid, and
     * the right and bottom are calculated automatically to match the left and top offset.
     * Of course, if you want to do the scaling with an asymmetrical scaling grid, you can specify
     * the width and height also.
     *
     * This allows you to more effortlesly make a scaling grid that is symmetrical in top-left
     * and bottom-right corners. If you want to do that, just leave the width and height parameters
     * of the scale9grid rectangle to zero (which is the default in Rectangle constructor).
     *
     * Visit www.avocado.fi/blog for more free classes.
     *
     * You may distribute this class freely, provided it is not modified in any way
     * (including removing this header or changing the package path).
     *
     * Please contact joonas@avocado.fi prior to distributing modified versions of this class.
     *
     * Usage:
     * var myBitmap:Scale9Bitmap = new Scale9Bitmap(myBitmapData, new Rectangle(5, 5, 10, 10), true);
     *
     * If myBitmapData would have the width and height of 20, the above scale grid would specify a
     * scaling that leaves 5 pixels for the borders in each side.
     *
     * For further explanation of the grid scaling functionality, see:
     * http://livedocs.adobe.com/flex/3/langref/flash/display/DisplayObject.html#scale9Grid
     *
     */
    public class Scale9Bitmap extends Sprite
    {
        
        //-----------------------------------------------------------------------------
        //  Constructor
        //-----------------------------------------------------------------------------
        /**
         * Construct a new Scale9Bitmap instance
         *
         * @param bitmapdata:BitmapData The bitmapData of the image to be used as the source
         * @param scale9Grid:Rectangle The rectangle to use as scale grid
         * @param smoothing:Boolean Wether the bitmap should use smoothing when rotated
         */
        public function Scale9Bitmap(bitmapData:BitmapData, scale9Grid:Rectangle)
        {
            super();
            
            if (scale9Grid.width  <= 0) scale9Grid.width  = bitmapData.width  - (scale9Grid.x * 2);
            if (scale9Grid.height <= 0) scale9Grid.height = bitmapData.height - (scale9Grid.y * 2);
            
            _bitmapData     = bitmapData;
            _scale9Grid     = scale9Grid;
            
            rightColWidth = _bitmapData.width - (scale9Grid.x + scale9Grid.width);
            bottomRowHeight = _bitmapData.height - (scale9Grid.y + scale9Grid.height);
            
            if (_bitmapData.width < scale9Grid.width + scale9Grid.x)
            {
                throw ("Grid width exceeds bitmapdata width (" + _bitmapData.width + " < left[" + scale9Grid.x + "] + width[" + scale9Grid.width + "])");
            }
            
            if (_bitmapData.height < scale9Grid.height + scale9Grid.y)
            {
                throw ("Grid height exceeds bitmapdata height (" + _bitmapData.height + " < top[" + scale9Grid.y + "] + height[" + scale9Grid.height + "])");
            }
            
            if (scale9Grid.width <= 0)
            {
                throw ("Grid width must be greater than zero (width: " + scale9Grid.width + ")");
            }
            
            if (scale9Grid.height <= 0)
            {
                throw ("Grid height must be greater than zero (height: " + scale9Grid.height + ")");
            }
            
            _width = _bitmapData.width;
            _height = _bitmapData.height;
            
            locked = true;
            width = _bitmapData.width;
            height = _bitmapData.height;
            locked = false;
        }
        
        
        private var bmd:BitmapData;
        
        private var rightColWidth:Number = 0;
        private var bottomRowHeight:Number = 0;
        private var scaleMatrix:Matrix;
        private var drawClipRect:Rectangle;
        
        private var _bitmapData:BitmapData;
        private var _scale9Grid:Rectangle;
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _locked:Boolean = false;
        private var _showGrid:Boolean = false;
        
        // Private variable storage to prevent variables
        // from being created on the render function
        private var tW:Number;
        private var tH:Number;
        private var tWScale:Number;
        private var tHScale:Number;
        private var tWOuterScale1:Number;
        private var tHOuterScale1:Number;
        private var tWOuterScale2:Number;
        private var tHOuterScale2:Number;
        private var tX1:Number;
        private var tX2:Number;
        private var tX3:Number;
        private var tY1:Number;
        private var tY2:Number;
        private var tY3:Number;
        
        // Draw the bitmapData on canvas scaled by the scale9grid Rectangle
        private function render():void {
            
            tW = innerWidth;
            tH = innerHeight;
            tWScale = tW / scale9Grid.width;
            tHScale = tH / scale9Grid.height;
            
            bmd = new BitmapData(_width, _height, true, 0x000000);
            
            tX1 = scale9Grid.width * tWScale;
            tY1 = scale9Grid.height * tHScale;
            
            tX2 = scale9Grid.x - scale9Grid.x * tWScale;
            tY2 = scale9Grid.y - scale9Grid.y * tHScale;
            
            tX3 = scale9Grid.x + scale9Grid.width + (tW - scale9Grid.width);
            tY3 = scale9Grid.y + scale9Grid.height + (tH - scale9Grid.height);
            
            // Draw Top-Left
            scaleMatrix = new Matrix(1, 0, 0, 1, 0, 0);
            drawClipRect = new Rectangle(0, 0, scale9Grid.x, scale9Grid.y);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Top-Center
            scaleMatrix = new Matrix(tWScale, 0, 0, 1, tX2, 0);
            drawClipRect = new Rectangle(scale9Grid.x, 0, tX1, scale9Grid.y);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Top-Right
            scaleMatrix = new Matrix(1, 0, 0, 1, (tW - scale9Grid.width), 0);
            drawClipRect = new Rectangle(tX3, 0, rightColWidth, scale9Grid.y);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Middle-Left
            scaleMatrix = new Matrix(1, 0, 0, tHScale, 0, tY2);
            drawClipRect = new Rectangle(0, scale9Grid.y, scale9Grid.x, tY1);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Middle-Center
            scaleMatrix = new Matrix(tWScale, 0, 0, tHScale, tX2, tY2);
            drawClipRect = new Rectangle(scale9Grid.x, scale9Grid.y, tX1, tY1);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Middle-Right
            scaleMatrix = new Matrix(1, 0, 0, tHScale, (tW - scale9Grid.width), tY2);
            drawClipRect = new Rectangle(tX3, scale9Grid.y, rightColWidth, tY1);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Bottom-Left
            scaleMatrix = new Matrix(1, 0, 0, 1, 0, (tH - scale9Grid.height));
            drawClipRect = new Rectangle(0, tY3, scale9Grid.x, bottomRowHeight);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Bottom-Center
            scaleMatrix = new Matrix(tWScale, 0, 0, 1, tX2, (tH - scale9Grid.height));
            drawClipRect = new Rectangle(scale9Grid.x, tY3, tX1, bottomRowHeight);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            // Draw Bottom-Right
            scaleMatrix = new Matrix(1, 0, 0, 1, (tW - scale9Grid.width), (tH - scale9Grid.height));
            drawClipRect = new Rectangle(tX3, tY3, rightColWidth, bottomRowHeight);
            bmd.draw(_bitmapData, scaleMatrix, null, null, drawClipRect);
            
            this.graphics.clear();
            this.graphics.beginBitmapFill(bmd, null, false, true);
            this.graphics.drawRect(0, 0, _width, _height);
            this.graphics.endFill();
            
            if (this.showGrid) {
                
                this.graphics.lineStyle(1, 0x00ff00);
                
                // Drop top line
                this.graphics.moveTo(0, scale9Grid.y);
                this.graphics.lineTo(_width, scale9Grid.y);
                
                // Drop bottom line
                this.graphics.moveTo(0, tY3);
                this.graphics.lineTo(_width, tY3);
                
                // Drop left line
                this.graphics.moveTo(scale9Grid.x, 0);
                this.graphics.lineTo(scale9Grid.x, _height);
                
                // Drop right line
                this.graphics.moveTo(tX3, 0);
                this.graphics.lineTo(tX3, _height);
                
            }
            
        }
        
        override public function set scale9Grid(rect:Rectangle):void {
            _scale9Grid = rect;
            if (!locked) render();
        }
        
        override public function get scale9Grid():Rectangle {
            return _scale9Grid;
        }
        
        public function set innerWidth(value:Number):void {
            width = value + scale9Grid.x + rightColWidth;
        }
        
        public function get innerWidth():Number {
            return _width - scale9Grid.x - rightColWidth;
        }
        
        public function set innerHeight(value:Number):void {
            height = value + scale9Grid.y + bottomRowHeight;
        }
        
        public function get innerHeight():Number {
            return _height - scale9Grid.y - bottomRowHeight;
        }
        
        public function get bitmapData():BitmapData {
            return _bitmapData;
        }
        
        override public function set width(value:Number):void {
            if (isNaN(value)) value = 0;
            value = Math.max(1, value);
            _width = Math.round(value);
            if (!locked) render();
        }
        
        override public function get width():Number {
            return _width;
        }
        
        override public function set height(value:Number):void {
            if (isNaN(value)) value = 0;
            value = Math.max(1, value);
            _height = Math.round(value);
            if (!locked) render();
        }
        
        override public function get height():Number {
            return _height;
        }
        
        override public function set scaleX(value:Number):void {
            width = _bitmapData.width * value;
        }
        
        override public function get scaleX():Number {
            return width / _bitmapData.width;
        }
        
        override public function set scaleY(value:Number):void {
            height = _bitmapData.height * value;
        }
        
        override public function get scaleY():Number {
            return height / _bitmapData.height;
        }
        
        override public function set x(value:Number) : void {
            super.x = Math.round(value);
        }
        
        override public function set y(value:Number) : void {
            super.y = Math.round(value);
        }
        
        /**
         * Set scale9grid visibility in the rendered object for debugging
         * the grid placement and position. If set to true, green lines
         * are drawn where the grid slicing is set.
         */
        public function set showGrid(value:Boolean):void {
            _showGrid = value;
            if (!locked) render();
        }
        
        public function get showGrid():Boolean {
            return _showGrid;
        }
        
        public function set locked(value:Boolean):void {
            if (_locked == value) return;
            _locked = value;
            if (!locked) render();
        }
        
        public function get locked():Boolean {
            return _locked;
        }
        
		//ends
    }
}