/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing{
	
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.EmptyLayout;
import org.aswing.geom.IntDimension;
import org.aswing.Insets;
import org.aswing.geom.IntRectangle;

/**
 * BorderLayout排列并缩放一个容器内的组件以适应5个区域：
 * 北，南，东，西，和中间
 * 每个区域只能容纳一个组件，并且指定一个对应的常量
 * <code>NORTH</code>, <code>SOUTH</code>, <code>EAST</code>,
 * <code>WEST</code>, and <code>CENTER</code>.
 * 往一个使用BorderLayout的容器中添加组件时，使用这5个常量  
 * 例如：
 * <pre>
 *    var p:JPanel = new JPanel();
 *    p.setLayout(new BorderLayout());
 *    p.append(new JButton("Okay"), BorderLayout.SOUTH);
 * </pre>
 * 为了方便起见，<code>BorderLayout</code>默认使用<code>CENTER</code>常量
 * <pre>
 *    var p2:JPanel = new JPanel();
 *    p2.setLayout(new BorderLayout());
 *    p2.append(new TextArea());  //与 p.append(new JTextArea(), BorderLayout.CENTER);相同
 * </pre>
 * 
 * <p>
 * 下面的图片描述了BorderLayout排列子组件的方式
 * <br></br>
 * <img src="../../aswingImg/BorderLayout.JPG" ></img>
 * </p>
 * @author iiley
 */
 
public class BorderLayout extends EmptyLayout{
	private var hgap:Number;

	private var vgap:Number;

	private var north:Component;

	private var west:Component;

	private var east:Component;

    private var south:Component;

	private var center:Component;
    
    private var firstLine:Component;

	private var lastLine:Component;

	private var firstItem:Component;

	private var lastItem:Component;
	
	private var defaultConstraints:String;

    /**
     * 适应北面布局（容器的顶部）。
     */
    public static const NORTH:String  = "North";

    /**
     * 适应南面布局 （容器的底部）。
     */
    public static const SOUTH:String  = "South";

    /**
     * 适应东面布局 （容器的右边）。
     */
    public static const EAST :String  = "East";

    /**
     * 适应西面布局 （容器的左边）。
     */
    public static const WEST :String  = "West";

    /**
     * 适应中间布局约束 （容器的中间）
     */
    public static const CENTER:String  = "Center";

	
	public static const BEFORE_FIRST_LINE:String  = "First";


    public static const AFTER_LAST_LINE:String  = "Last";


    public static const BEFORE_LINE_BEGINS:String  = "Before";


    public static const AFTER_LINE_ENDS:String  = "After";


    public static const PAGE_START:String  = BEFORE_FIRST_LINE;


    public static const PAGE_END:String  = AFTER_LAST_LINE;


    public static const LINE_START:String  = BEFORE_LINE_BEGINS;


    public static const LINE_END:String  = AFTER_LINE_ENDS;

    /**
     * 构造一个BorderLayout并指定组件之间的间隔
     * <code>hgap</code>指定横向间隔
     * <code>vgap</code>指定纵向间隔。
     * @param   hgap   横向间隔。
     * @param   vgap   纵向间隔。
     */
    public function BorderLayout(hgap:int = 0, vgap:int = 0) {
		this.hgap = hgap;
		this.vgap = vgap;
		this.defaultConstraints = CENTER; 
    }
	
	/**
	 * 
	 */
	public function setDefaultConstraints(constraints:Object):void {
		defaultConstraints = constraints.toString();
	}

    public function getHgap():int {
		return hgap;
    }
	
	/**
	 * 设定横向间隔
	 */
    public function setHgap(hgap:int):void {
		this.hgap = hgap;
    }

    public function getVgap():int {
		return vgap;
    }
	
	/**
	 *  设定纵向间隔
	 */
    public function setVgap(vgap:int):void {
		this.vgap = vgap;
    }
	
	/**
	 * 
	 */
    override public function addLayoutComponent(comp:Component, constraints:Object):void {
    	var name:String = constraints != null ? constraints.toString() : null;
	    addLayoutComponentByAlign(name, comp);
    }

    private function addLayoutComponentByAlign(name:String, comp:Component):void {
		if (name == null) {
	   		name = defaultConstraints;
		}

		if (CENTER == name) {
		    center = comp;
		} else if (NORTH == name) {
		    north = comp;
		} else if (SOUTH == name) {
		    south = comp;
		} else if (EAST == name) {
		    east = comp;
		} else if (WEST == name) {
		    west = comp;
		} else if (BEFORE_FIRST_LINE == name) {
		    firstLine = comp;
		} else if (AFTER_LAST_LINE == name) {
		    lastLine = comp;
		} else if (BEFORE_LINE_BEGINS == name) {
		    firstItem = comp;
		} else if (AFTER_LINE_ENDS == name) {
		    lastItem = comp;
		} else {
			//defaut center
		    center = comp;
		}
    }
    
	/**
	 * 
	 */
    override public function removeLayoutComponent(comp:Component):void {
		if (comp == center) {
		    center = null;
		} else if (comp == north) {
		    north = null;
		} else if (comp == south) {
		    south = null;
		} else if (comp == east) {
		    east = null;
		} else if (comp == west) {
		    west = null;
		}
		if (comp == firstLine) {
		    firstLine = null;
		} else if (comp == lastLine) {
		    lastLine = null;
		} else if (comp == firstItem) {
		    firstItem = null;
		} else if (comp == lastItem) {
		    lastItem = null;
		}
    }
	/**
	 * 
	 */
    override public function minimumLayoutSize(target:Container):IntDimension {
		return target.getInsets().getOutsideSize();
    }
	
	/**
	 * 
	 */
    override public function preferredLayoutSize(target:Container):IntDimension {
    	var dim:IntDimension = new IntDimension(0, 0);
	    var ltr:Boolean = true;
	    var c:Component = null;
		
		var d:IntDimension;
		if ((c=getChild(EAST,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width += d.width + hgap;
		    dim.height = Math.max(d.height, dim.height);
		}
		if ((c=getChild(WEST,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width += d.width + hgap;
		    dim.height = Math.max(d.height, dim.height);
		}
		if ((c=getChild(CENTER,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width += d.width;
		    dim.height = Math.max(d.height, dim.height);
		}
		if ((c=getChild(NORTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width = Math.max(d.width, dim.width);
		    dim.height += d.height + vgap;
		}
		if ((c=getChild(SOUTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width = Math.max(d.width, dim.width);
		    dim.height += d.height + vgap;
		}
	
		var insets:Insets = target.getInsets();
		dim.width += insets.left + insets.right;
		dim.height += insets.top + insets.bottom;
		return dim;
    }
	/**
	 *
	 */
    override public function getLayoutAlignmentX(target:Container):Number{
    	return 0.5;
    }
	
	/**
	 * 
	 */
    override public function getLayoutAlignmentY(target:Container):Number{
    	return 0.5;
    }

    /**
     * <p>
     * 布置指定容器。
     * </p>
     * <p>
     * //TODO 翻译（暂未理解）
     * This method actually reshapes the components in the specified
     * container in order to satisfy the constraints of this
     * <code>BorderLayout</code> object. The <code>NORTH</code>
     * and <code>SOUTH</code> components, if any, are placed at
     * the top and bottom of the container, respectively. The
     * <code>WEST</code> and <code>EAST</code> components are
     * then placed on the left and right, respectively. Finally,
     * the <code>CENTER</code> object is placed in any remaining
     * space in the middle.
     * </p>
     * <p>
     * 大部分应用程序不需要直接调用该方法。该方法在容器执行其<code>doLayout</code>
     * 方法时被调用。
     * </p>
     * @param   target   要布置的容器。
     * @see     Container
     * @see     Container#doLayout()
     */
    override public function layoutContainer(target:Container):void{
    	var td:IntDimension = target.getSize();
		var insets:Insets = target.getInsets();
		var top:int = insets.top;
		var bottom:int = td.height - insets.bottom;
		var left:int = insets.left;
		var right:int = td.width - insets.right;
	    var ltr:Boolean = true;
	    var c:Component = null;
	
		var d:IntDimension;
		if ((c=getChild(NORTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(left, top, right - left, d.height));
		    top += d.height + vgap;
		}
		if ((c=getChild(SOUTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(left, bottom - d.height, right - left, d.height));
		    bottom -= d.height + vgap;
		}
		if ((c=getChild(EAST,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(right - d.width, top, d.width, bottom - top));
		    right -= d.width + hgap;
		    //Flashout.log("East prefer size : " + d);
		}
		if ((c=getChild(WEST,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(left, top, d.width, bottom - top));
		    left += d.width + hgap;
		}
		if ((c=getChild(CENTER,ltr)) != null) {
		    c.setBounds(new IntRectangle(left, top, right - left, bottom - top));
		}
      
    }

    /**
     * 根据适应区域获取组件
     *
     * @param   key     需要的绝对位置
     *                  也就是 NORTH, SOUTH, EAST, 或 WEST。
     * @param   ltr     Is the component line direction left-to-right?
     * 					该组件方向是否从左向右？ //TODO 未理解...
     */
    private function getChild(key:String, ltr:Boolean):Component {
        var result:Component = null;

        if (key == NORTH) {
            result = (firstLine != null) ? firstLine : north;
        }
        else if (key == SOUTH) {
            result = (lastLine != null) ? lastLine : south;
        }
        else if (key == WEST) {
            result = ltr ? firstItem : lastItem;
            if (result == null) {
                result = west;
            }
        }
        else if (key == EAST) {
            result = ltr ? lastItem : firstItem;
            if (result == null) {
                result = east;
            }
        }
        else if (key == CENTER) {
            result = center;
        }
        if (result != null && !result.isVisible()) {
            result = null;
        }
        return result;
    }

    public function toString():String {
		return "BorderLayout[hgap=" + hgap + ",vgap=" + vgap + "]";
    }
}
}