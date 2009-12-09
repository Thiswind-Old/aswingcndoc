/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing
{

import org.aswing.plaf.basic.BasicButtonUI;
import flash.display.SimpleButton;

/**
 * 按钮的一个实现。
 * An implementation of a "push" button.
 * @author iiley
 */
public class JButton extends AbstractButton
{
	public function JButton(text:String="", icon:Icon=null){
		super(text, icon);
		setName("JButton");
    	setModel(new DefaultButtonModel());
	}
	
	/**
     * 返回这个按钮在根容器中是否为默认按钮。
	 * Returns whether this button is the default button of its root pane or not.
     * @return true 这个按钮是根容器中的默认按钮, false 其它情况。
	 * @return true if this button is the default button of its root pane, false otherwise.
	 */
	public function isDefaultButton():Boolean{
		var rootPane:JRootPane = getRootPaneAncestor();
		if(rootPane != null){
			return rootPane.getDefaultButton() == this;
		}
		return false;
	}
	
	/**
     * 包装一个 SimpleButton 来显示这个按钮。 
	 * Wrap a SimpleButton to be this button's representation.
     * @param btn 被包装的 SimpleButton 。
	 * @param btn the SimpleButton to be wrap.
	 */
	override public function wrapSimpleButton(btn:SimpleButton):void{
		mouseChildren = true;
		drawTransparentTrigger = false;
		setShiftOffset(0);
		setIcon(new SimpleButtonIcon(btn));
		setBorder(null);
		setMargin(new Insets());
		setBackgroundDecorator(null);
		setOpaque(false);
		setHorizontalTextPosition(AsWingConstants.CENTER);
		setVerticalTextPosition(AsWingConstants.CENTER);
	}
	
    override public function updateUI():void{
    	setUI(UIManager.getUI(this));
    }
	
    override public function getDefaultBasicUIClass():Class{
    	return org.aswing.plaf.basic.BasicButtonUI;
    }
    
	override public function getUIClassID():String{
		return "ButtonUI";
	}
	
}

}
