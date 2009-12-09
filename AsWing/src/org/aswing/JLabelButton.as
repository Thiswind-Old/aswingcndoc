/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing{

import org.aswing.plaf.basic.BasicLabelButtonUI;

/**
 * 一个模仿超链接的按钮。
 * A button that performances like a hyper link text.
 * @author iiley
 */
public class JLabelButton extends AbstractButton{
	
	protected var rolloverColor:ASColor;
	protected var pressedColor:ASColor;
	
    /**
     * 创建一个文字按钮。
     * Creates a label button.
     * @param text 文字。
     * @param text the text.
     * @param icon 标志。
     * @param icon the icon.
     * @param horizontalAlignment 水平布局，默认是 <cide>CENTER</cide>
     * @param horizontalAlignment the horizontal alignment, default is <code>CENTER</code>
     */	
	public function JLabelButton(text:String="", icon:Icon=null, horizontalAlignment:int=0){
		super(text, icon);
		setName("JLabelButton");
    	setModel(new DefaultButtonModel());
    	setHorizontalAlignment(horizontalAlignment);
	}
	
    override public function updateUI():void{
    	setUI(UIManager.getUI(this));
    }
	
    override public function getDefaultBasicUIClass():Class{
    	return org.aswing.plaf.basic.BasicLabelButtonUI;
    }
    
	override public function getUIClassID():String{
		return "LabelButtonUI";
	}
	
	/**
     * 设置当鼠标移到按钮上时，文字的颜色。
	 * Sets the color for text rollover state.
     * @param c 颜色
	 * @param c the color.
	 */
	public function setRollOverColor(c:ASColor):void{
		if(c != rolloverColor){
			rolloverColor = c;
			repaint();
		}
	}
	
	/**
     * 得到鼠标移到按钮上时，文字的颜色。
	 * Gets the color for text rollover state.
	 * @return 颜色。
	 */	
	public function getRollOverColor():ASColor{
		return rolloverColor;
	}	
	
	/**
     * 设置当按钮被选中或鼠标按下的时候，文字的颜色。
	 * Sets the color for text pressed/selected state.
     * @param c 颜色。
	 * @param c the color.
	 */	
	public function setPressedColor(c:ASColor):void{
		if(c != pressedColor){
			pressedColor = c;
			repaint();
		}
	}
	
	/**
     * 得到当按钮被选中或鼠标按下的时候，文字的颜色
	 * Gets the color for text pressed/selected state.
	 * @return 颜色。
	 */		
	public function getPressedColor():ASColor{
		return pressedColor;
	}	
}
}
