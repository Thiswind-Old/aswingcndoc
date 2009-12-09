/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing{
	import org.aswing.plaf.basic.BasicRadioButtonUI;
	
	
/**
 * 一个单选按钮的实现 -- 一个可以被选中或取消选中状态的组件，用来给用户展现
 * 其状态。
 * 使用一个 {@link ButtonGroup} 对象来创建一组按钮，其中只有一个按钮可以被选
 * 中。（创建一个 ButtonGroup 对象使用其 <code>append</code> 方法来向组中插入
 * JRadioButton 对象）
 * <blockquote>
 * <strong>注意：</strong>
 * ButtonGroup 对象只是在逻辑上进行组织 -- 不是显示上的组。
 * 要创建一个按钮面板，你仍然需要创建一个 {@link JPanel} 或相似的容器对象，然
 * 后插入一个 {@link org.aswing.border.Border} 到里面，使这个组从外观上区别与
 * 周围的组件。
 * </blockquote>
 * An implementation of a radio button -- an item that can be selected or
 * deselected, and which displays its state to the user.
 * Used with a {@link ButtonGroup} object to create a group of buttons
 * in which only one button at a time can be selected. (Create a ButtonGroup
 * object and use its <code>append</code> method to include the JRadioButton objects
 * in the group.)
 * <blockquote>
 * <strong>Note:</strong>
 * The ButtonGroup object is a logical grouping -- not a physical grouping.
 * To create a button panel, you should still create a {@link JPanel} or similar
 * container-object and add a {@link org.aswing.border.Border} to it to set it off from surrounding
 * components.
 * </blockquote>
 * @author iiley
 */	
public class JRadioButton extends JToggleButton{
	
	public function JRadioButton(text:String="", icon:Icon=null)
	{
		super(text, icon);
		setName("JRadioButton");
	}
	
    override public function getDefaultBasicUIClass():Class{
    	return org.aswing.plaf.basic.BasicRadioButtonUI;
    }
    
	override public function getUIClassID():String{
		return "RadioButtonUI";
	}
	
}
}
