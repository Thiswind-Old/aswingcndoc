/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing{
	
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.EmptyLayout;
import org.aswing.geom.IntDimension;
import org.aswing.geom.IntRectangle;
import org.aswing.Insets;


/**
 * 允许垂直或水平布置多个组件的布局管理器。这些组件将不包装。组件的宽度，高度，最佳宽度，最佳高度都不会
 * 影响该布局管理器布置组件的方式。注意，该布局管理器的工作方式并不和Java swing的boxlayout相同。
 * <p>
 * 如果boxlayout被设置为X_AXIS，无论其内部组件的高度，最佳高度，最佳宽度为多少，它都将平均分配子组件的宽度。
 * 所有子组件的高度都与他们的父容器相同。
 * 以下图片说明这一点：
 * <img src="../../aswingImg/BoxLayout_X_AXIS.JPG" ></img>
 * </p>
 * <br/>
 * <br/>
 * <p>
 * 设置成Y_AXIS后的工作方式也相同。
 * </p>
 * <br>
 * 
 * 注意该布局将会先减去所有的间隔然后在平均布置所有组件。
 * 如果你有一个100像素的容器，其内部有5个组件，容器的布局管理器为boxlayout，并且设置为X_AXIS，间距为20。
 * 你将看不到任何一个组件。
 * 因为布局管理器会先从可视区域减去 20(间距)*5(个组件) = 100像素 的空白。所以，每个组件的宽度将为0。
 * 当你使用该布局管理器的时候需要注意这点。
 * </br>
 * @author iiley
 */
public class BoxLayout extends EmptyLayout
{
	/**
	 * 指定组件应该从左到右放置。
     */
    public static const X_AXIS:int = 0;
    
    /**
     * 指定组件应该从上到下放置。
     */
    public static const Y_AXIS:int = 1;
    
    
    private var axis:int;
    private var gap:int;
    
    /**
     * @param axis (可选)布置组件时使用的轴，默认为 X_AXIS。
     * @param gap  (可选)子组件之间的间距，默认为0。
     * 
     * @see #X_AXIS
     * @see #X_AXIS
     */
    public function BoxLayout(axis:int=X_AXIS, gap:int=0){
    	setAxis(axis);
    	setGap(gap);
    }
    
    /**
     * 设置新的用于布局组件的轴。
     * @param axis 新的轴，默认为 X_AXIS
     */
    public function setAxis(axis:int=X_AXIS):void {
    	this.axis = axis;
    }
    
    /**
     * 返回用于布局组件的轴。
     * @return 用于布局组件的轴
     */
    public function getAxis():int {
    	return axis;	
    }
    
    /**
     * 设置新的间距。
     * @param gap 新的间距
     */	
    public function setGap(gap:int=0):void {
    	this.gap = gap
    }
    
    /**
     * 返回间距。
     * @return 间距。
     */
    public function getGap():int {
    	return gap;	
    }
    
    override public function preferredLayoutSize(target:Container):IntDimension{
    	return getCommonLayoutSize(target, false);
    }

    override public function minimumLayoutSize(target:Container):IntDimension{
    	return target.getInsets().getOutsideSize();
    }
    
    override public function maximumLayoutSize(target:Container):IntDimension{
    	return getCommonLayoutSize(target, true);
    }    
    
    
    private function getCommonLayoutSize(target:Container, isMax:Boolean):IntDimension{
    	var count:int = target.getComponentCount();
    	var insets:Insets = target.getInsets();
    	var width:int = 0;
    	var height:int = 0;
    	var amount:int = 0;
    	for(var i:int=0; i<count; i++){
    		var c:Component = target.getComponent(i);
    		if(c.isVisible()){
	    		var size:IntDimension = isMax ? c.getMaximumSize() : c.getPreferredSize();
	    		width = Math.max(width, size.width);
	    		height = Math.max(height, size.height);
	    		amount++;
    		}
    	}
    	if(axis == Y_AXIS){
    		height = height*amount;
    		if(amount > 0){
    			height += (amount-1)*gap;
    		}
    	}else{
    		width = width*amount;
    		if(amount > 0){
    			width += (amount-1)*gap;
    		}
    	}
    	var dim:IntDimension = new IntDimension(width, height);
    	return insets.getOutsideSize(dim);
    }
    
    override public function layoutContainer(target:Container):void{
    	var count:int = target.getComponentCount();
    	var amount:int = 0;
    	for(var i:int=0; i<count; i++){
    		var c:Component = target.getComponent(i);
    		if(c.isVisible()){
	    		amount ++;
    		}
    	}
    	var size:IntDimension = target.getSize();
    	var insets:Insets = target.getInsets();
    	var rd:IntRectangle = insets.getInsideBounds(size.getBounds());
    	var ch:int;
    	var cw:int;
    	if(axis == Y_AXIS){
    		ch = Math.floor((rd.height - (amount-1)*gap)/amount);
    		cw = rd.width;
    	}else{
    		ch = rd.height;
    		cw = Math.floor((rd.width - (amount-1)*gap)/amount);
    	}
    	var x:int = rd.x;
    	var y:int = rd.y;
    	var xAdd:int = (axis == Y_AXIS ? 0 : cw+gap);
    	var yAdd:int = (axis == Y_AXIS ? ch+gap : 0);
    	
    	for(var ii:int=0; ii<count; ii++){
    		var comp:Component = target.getComponent(ii);
    		if(comp.isVisible()){
	    		comp.setBounds(new IntRectangle(x, y, cw, ch));
	    		x += xAdd;
	    		y += yAdd;
    		}
    	}
    }
    
	/**
	 * return 0.5
	 */
    override public function getLayoutAlignmentX(target:Container):Number{
    	return 0.5;
    }

	/**
	 * return 0.5
	 */
    override public function getLayoutAlignmentY(target:Container):Number{
    	return 0.5;
    }
}
}