/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.greensock.transform.utils {
        import flash.geom.Matrix;
/**
 * Used by TransformManager to perform various Matrix calculations. <br /><br />
 *
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 *
 * @author Jack Doyle, jack@greensock.com
 */
        public class MatrixTools {
                private static const VERSION:Number = 1.0;

                /** @private **/
                public static function getDirectionX($m:Matrix):Number {
                        var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
                        if ($m.a < 0) {
                                return -sx;
                        } else {
                                return sx;
                        }
                }

                /** @private **/
                public static function getDirectionY($m:Matrix):Number {
                        var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
                        if ($m.d < 0) {
                                return -sy;
                        } else {
                                return sy;
                        }
                }

                /** @private **/
                public static function getScaleX($m:Matrix):Number {
                        var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
                        if ($m.a < 0 && $m.d > 0) {
                                return -sx;
                        } else {
                                return sx;
                        }
                }

                /** @private **/
                public static function getScaleY($m:Matrix):Number {
                        var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
                        if ($m.d < 0 && $m.a > 0) {
                                return -sy;
                        } else {
                                return sy;
                        }
                }

                /** @private **/
                public static function getAngle($m:Matrix):Number { //If a DisplayObject is flipped (negative scaleX or scaleY), you cannot simply do Math.atan2($m.b, $m.a)!
                        var a:Number = Math.atan2($m.b, $m.a);
                        if ($m.a < 0 && $m.d >= 0) {
                                return (a <= 0) ? a + Math.PI : a - Math.PI;
                        } else {
                                return a;
                        }
                }

                /** @private Flash has a somewhat odd way of reporting rotation natively - this replicates it. **/
                public static function getFlashAngle($m:Matrix):Number {
                        var a:Number = Math.atan2($m.b, $m.a);
                        if (a < 0 && $m.a * $m.d < 0) {
                                a = (a - Math.PI) % Math.PI;
                        }
                        return a;
                }

                /** @private **/
                public static function scaleMatrix($m:Matrix, $sx:Number, $sy:Number, $angle:Number, $skew:Number):void {
                        var cosAngle:Number = Math.cos($angle);
                        var sinAngle:Number = Math.sin($angle);
                        var cosSkew:Number = Math.cos($skew);
                        var sinSkew:Number = Math.sin($skew);

                        var a:Number = (cosAngle * $m.a + sinAngle * $m.b) * $sx;
                        var b:Number = (cosAngle * $m.b - sinAngle * $m.a) * $sy;
                        var c:Number = (cosSkew * $m.c - sinSkew * $m.d) * $sx;
                        var d:Number = (cosSkew * $m.d + sinSkew * $m.c) * $sy;

                        $m.a = cosAngle * a - sinAngle * b;
                        $m.b = cosAngle * b + sinAngle * a;
                        $m.c = cosSkew * c + sinSkew * d;
                        $m.d = cosSkew * d - sinSkew * c;
                }

                /** @private **/
                public static function getSkew($m:Matrix):Number {
                        return Math.atan2($m.c, $m.d);
                }

                /** @private **/
                public static function setSkewX($m:Matrix, $skewX:Number):void {
                        var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
                        $m.c = -sy * Math.sin($skewX);
                        $m.d =  sy * Math.cos($skewX);
                }

                /** @private **/
                public static function setSkewY($m:Matrix, $skewY:Number):void {
                        var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
                        $m.a = sx * Math.cos($skewY);
                        $m.b = sx * Math.sin($skewY);
                }

        }
}
