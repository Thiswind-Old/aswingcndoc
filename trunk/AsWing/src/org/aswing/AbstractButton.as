/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing{

import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.DisplayObject;

import org.aswing.error.ImpMissError;
import org.aswing.event.*;
import org.aswing.plaf.*;	
import org.aswing.util.*;
import flash.display.SimpleButton;
	
/**
 * 当按钮模型执行动作时分发该事件，通常情况下是由用户点击按钮或者调用 <code>doClick()</code> 方法。
 * @eventType org.aswing.event.AWEvent.ACT
 * @see org.aswing.AbstractButton#addActionListener()
 */
[Event(name="act", type="org.aswing.event.AWEvent")]

/**
 * 当按钮的状态发生改变时分发该事件，有以下这些状态：
 * <ul>
 * <li>可用</li>
 * <li>鼠标经过</li>
 * <li>鼠标按下</li>
 * <li>鼠标释放</li>
 * <li>被选中</li>
 * </ul>
 * </p>
 * <p>
 * 按钮总是触发 <code>programmatic=false</code> InteractiveEvent.
 * </p>
 * @eventType org.aswing.event.InteractiveEvent.STATE_CHANGED
 */
[Event(name="stateChanged", type="org.aswing.event.InteractiveEvent")]
	
/**
 *  按钮的选择状态被改变时触发该事件。
 * <p>
 * 按钮总是触发 <code>programmatic=false</code> InteractiveEvent.
 * </p>
 *  @eventType org.aswing.event.InteractiveEvent.SELECTION_CHANGED
 */
[Event(name="selectionChanged", type="org.aswing.event.InteractiveEvent")]

/**
 * 定义按钮和菜单项的通用行为。
 * @author iiley
 */
public class AbstractButton extends Component{
	
	/**
	 * 一种快速访问AsWingConstants中CENTER常量的方式
	 * @see org.aswing.AsWingConstants
	 */
	public static const CENTER:int  = AsWingConstants.CENTER;
	/**
	 * 一种快速访问AsWingConstants中TOP常量的方式
	 * @see org.aswing.AsWingConstants
	 */
	public static const TOP:int     = AsWingConstants.TOP;
	/**
	 * 一种快速访问AsWingConstants中LEFT常量的方式
	 * @see org.aswing.AsWingConstants
	 */
    public static const LEFT:int    = AsWingConstants.LEFT;
	/**
	 * 一种快速访问AsWingConstants中BOTTOM常量的方式
	 * @see org.aswing.AsWingConstants
	 */
    public static const BOTTOM:int  = AsWingConstants.BOTTOM;
 	/**
	 * 一种快速访问AsWingConstants中RIGHT常量的方式
	 * @see org.aswing.AsWingConstants
	 */
    public static const RIGHT:int   = AsWingConstants.RIGHT;
	/**
	 * 一种快速访问AsWingConstants中HORIZONTAL常量的方式
	 * @see org.aswing.AsWingConstants
	 */        
	public static const HORIZONTAL:int = AsWingConstants.HORIZONTAL;
	/**
	 * 一种快速访问AsWingConstants中VERTICAL常量的方式
	 * @see org.aswing.AsWingConstants
	 */
	public static const VERTICAL:int   = AsWingConstants.VERTICAL;	
	

    /** 
    确定按钮状态的数据模型。
    */
    private var model:ButtonModel;
    
    private var text:String;
	private var displayText:String;
	private var mnemonic:int;
	private var mnemonicIndex:int;
    private var margin:Insets;
    private var defaultMargin:Insets;

    // Button icons
    private var       defaultIcon:Icon;
    private var       pressedIcon:Icon;
    private var       disabledIcon:Icon;

    private var       selectedIcon:Icon;
    private var       disabledSelectedIcon:Icon;

    private var       rolloverIcon:Icon;
    private var       rolloverSelectedIcon:Icon;
    
    // Display properties
    private var    rolloverEnabled:Boolean;

    // Icon/Label Alignment
    private var        verticalAlignment:int;
    private var        horizontalAlignment:int;
    
    private var        verticalTextPosition:int;
    private var        horizontalTextPosition:int;

    private var        iconTextGap:int;	
    private var        shiftOffset:int = 0;
    private var        shiftOffsetSet:Boolean=false;
	
	public function AbstractButton(text:String="", icon:Icon=null){
		super();
		setName("AbstractButton");
		
    	rolloverEnabled = true;
    	
    	verticalAlignment = CENTER;
    	horizontalAlignment = CENTER;
    	verticalTextPosition = CENTER;
    	horizontalTextPosition = RIGHT;
    	
    	iconTextGap = 2;
    	this.text = text;
    	this.analyzeMnemonic();
    	this.defaultIcon = icon;
    	//setText(text);
    	//setIcon(icon);
    	initSelfHandlers();
    	updateUI();
    	installIcon(defaultIcon);
	}

    /**
     * 返回表示此按钮的模型。
     * @return <code>model</code> 属性
     * @see #setModel()
     */
    public function getModel():ButtonModel{
        return model;
    }
    
    /**
     * 设置表示此按钮的模型。
     * @param m 新的 <code>ButtonModel</code>
     * @see #getModel()
     */
    public function setModel(newModel:ButtonModel):void {
        
        var oldModel:ButtonModel = getModel();
        
        if (oldModel != null) {
        	oldModel.removeActionListener(__modelActionListener);
            oldModel.removeStateListener(__modelStateListener);
            oldModel.removeSelectionListener(__modelSelectionListener);
        }
        
        model = newModel;
        
        if (newModel != null) {
        	newModel.addActionListener(__modelActionListener);
            newModel.addStateListener(__modelStateListener);
            newModel.addSelectionListener(__modelSelectionListener);
        }

        if (newModel != oldModel) {
            revalidate();
            repaint();
        }
    }
         
    /**
     * 将 UI 属性重置为当前外观中的一个值。
     * AbstractButton 的子类型应该重写此方法来更新 UI。
     * 例如，JButton 可以执行以下操作：
     * <pre>
     *      setUI(ButtonUI(UIManager.getUI(this)));
     * </pre>
     */
    override public function updateUI():void{
    	throw new ImpMissError();
    }
    
    /**
     * 通过程序调用来执行一次"单击"。
     */
    public function doClick():void{
    	dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, 0, 0));
    	dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, 0, 0));
    	if(isOnStage()){
    		dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, 0, 0));
    	}else{
    		AsWingManager.getStage().dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, 0, 0));
    	}
    	dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, 0, 0));
    	dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false, 0, 0));
    }
    
    /**
     * 将一个 ActionListener 添加到按钮中。当用户点击按钮的时候会触发一次动作事件。
	 * @param listener 监听器
	 * @param priority 优先级
	 * @param useWeakReference 决定监听器的引用方式是强引用还是弱引用。
	 * @see org.aswing.event.AWEvent#ACT
     */
    public function addActionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void{
    	addEventListener(AWEvent.ACT, listener, false, priority, useWeakReference);
    }
	/**
	 * 删除一个监听器。
	 * @param listener 被删除的监听器。
	 * @see org.aswing.event.AWEvent#ACT
	 */
	public function removeActionListener(listener:Function):void{
		removeEventListener(AWEvent.ACT, listener);
	}    
    	
	/**
	 * 增加对按钮选择状态改变的事件监听。当按钮选择状态改变时，当选中
	 * 或失去选中状态时触发。
	 * @param listener 监听器
	 * @param priority 优先级
	 * @param useWeakReference 决定监听器的引用方式是强引用还是弱引用。
	 * @see org.aswing.event.InteractiveEvent#SELECTION_CHANGED
	 */	
	public function addSelectionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void{
		addEventListener(InteractiveEvent.SELECTION_CHANGED, listener, false, priority);
	}

	/**
	 * 删除一个选择事件监听器。
	 * @param listener 被删除的监听器。
	 * @see org.aswing.event.InteractiveEvent#SELECTION_CHANGED
	 */
	public function removeSelectionListener(listener:Function):void{
		removeEventListener(InteractiveEvent.SELECTION_CHANGED, listener);
	}
	
	/**
	 * 增加对按钮状态改变的事件。
	 * <p>
	 * 当按钮的状态改变，有以下这些状态：
	 * <ul>
	 * <li>可用</li>
	 * <li>鼠标经过</li>
	 * <li>鼠标按下</li>
	 * <li>鼠标释放</li>
	 * <li>被选中</li>
	 * </ul>
	 * </p>
	 * @param listener 监听器
	 * @param priority 优先级
	 * @param useWeakReference 决定监听器的引用方式是强引用还是弱引用。
	 * @see org.aswing.event.InteractiveEvent#STATE_CHANGED
	 */	
	public function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void{
		addEventListener(InteractiveEvent.STATE_CHANGED, listener, false, priority);
	}	
	
	/**
	 * 删除状态监听器。
	 * @param listener 被删除的监听器。
	 * @see org.aswing.event.InteractiveEvent#STATE_CHANGED
	 */	
	public function removeStateListener(listener:Function):void{
		removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
	}
	
    /**
	 * 按钮可用（或者禁用）
	 * @param b  true 为可用, 否则为 false
     */
	override public function setEnabled(b:Boolean):void{
		if (!b && model.isRollOver()) {
	    	model.setRollOver(false);
		}
        super.setEnabled(b);
        model.setEnabled(b);
    }    

    /**
	 * 返回按钮的状态。为true时开关按钮被选中，false时未被选中。
	 * @return true时开关按钮被选中, 否则为false
     */
    public function isSelected():Boolean{
        return model.isSelected();
    }
    
    /**
	 * 设置按钮的状态。注意，这个方法不会触发事件。
	 * 调用 <code>click</code> 来程序化的执行一次动作改变。
	 * @param b  如果按钮被选中为true，否则为false
     */
    public function setSelected(b:Boolean):void{
        model.setSelected(b);
    }
    
    /**
	 * 设置 <code>rolloverEnabled</code> 属性，只有当它设置成
	 * <code>true</code> 的时候鼠标经过效果才能发生。
	 * <code>rolloverEnabled</code> 默认属性为 <code>false</code>。
	 * 一些外观可能没有实现鼠标经过时的效果；它们会忽略这个属性。
	 * @param b 如果为 <code>true</code>， 鼠标经过时绘制效果。
     * @see #isRollOverEnabled()
     */
    public function setRollOverEnabled(b:Boolean):void{
    	if(rolloverEnabled != b){
    		rolloverEnabled = b;
    		repaint();
    	}
    }
    
    /**
	 * 得到 <code>rolloverEnabled</code> 属性。
	 * 
	 * @return <code>rolloverEnabled</code> 属性值
     * @see #setRollOverEnabled()
     */    
    public function isRollOverEnabled():Boolean{
    	return rolloverEnabled;
    }

	/**
	 * 设置按钮边框和标签之间的空白。将该空白设置为 <code>null</code> 会造成按钮使用默认空白。
	 * 按钮的默认 <code>Border</code> 对象将使用该值来创建适当的空白。
	 * 不过，如果在按钮上设置非默认边框，
	 * 则由 <code>Border</code> 对象负责创建适当的空白（否则此属性将被忽略）。
	 * 
	 * @param m 边框和标签之间的空白
	 */
	public function setMargin(m:Insets):void{
        // Cache the old margin if it comes from the UI
        if(m is UIResource) {
            defaultMargin = m;
        }
        
        // If the client passes in a null insets, restore the margin
        // from the UI if possible
        if(m == null && defaultMargin != null) {
            m = defaultMargin;
        }

        var old:Insets = margin;
        margin = m;
        if (old == null || !m.equals(old)) {
            revalidate();
        	repaint();
        }
	}
	
	public function getMargin():Insets{
		var m:Insets = margin;
		if(margin == null){
			m = defaultMargin;
		}
		if(m == null){
			return new InsetsUIResource();
		}else if(m is UIResource){//make it can be replaced by LAF
			return new InsetsUIResource(m.top, m.left, m.bottom, m.right);
		}else{
			return new Insets(m.top, m.left, m.bottom, m.right);
		}
	}
	
	/**
	 * 包装一个SimpleButton作为按钮的外观。
	 * @param btn 被包装的SimpleButton。
	 */
	public function wrapSimpleButton(btn:SimpleButton):void{
		setShiftOffset(0);
		setIcon(new SimpleButtonIconToggle(btn));
		setBorder(null);
		setMargin(new Insets());
		setBackgroundDecorator(null);
		setOpaque(false);
	}
		
	/**
	 * 在设置文本的时候在文本中加上一个“&”（助记修饰符）。比如，如果你设置文本
	 * 的内容为“&File”，显示的时候是“File”，“F”就是助记符。
	 * <p>
	 * 这个方法会使得按钮重画，但是不会重新调整布局，所以如果你为文本设置了不同的字体大小，
	 * 你需要调用 <code>revalidate()</code> 来重新进行布局调整。
	 * </p>
	 * @param text 按钮的文本
	 * @see #getDisplayText()
	 * @see #getMnemonic()
	 * @see #getMnemonicIndex()
	 */
	public function setText(text:String):void{
		if(this.text != text){
			this.text = text;
			analyzeMnemonic();
			repaint();
			invalidate();
		}
	}
	
	private function analyzeMnemonic():void{
		displayText = text;
		mnemonic = -1;
		mnemonicIndex = -1;
		if(text == null){
			return;
		}
		var mi:int = text.indexOf("&");
		var mc:String = "";
		var found:Boolean = false;
		while(mi >= 0){
			if(mi+1 < text.length){
				mc = text.charAt(mi+1);
				if(StringUtils.isLetter(mc)){
					found = true;
					break;
				}
			}else{
				break;
			}
			mi = text.indexOf("&", mi+1);
		}
		if(found){
			displayText = text.substring(0, mi) + text.substring(mi+1);
			mnemonic = mc.toUpperCase().charCodeAt(0);
			mnemonicIndex = mi;
		}
	}
	
	/**
	 * 返回文本，包含“&”（助记修饰符）。
	 * @return 文本。
	 * @see #getDisplayText()
	 */
	public function getText():String{
		return text;
	}
	
	/**
	 * 返回显示文本，这个文本不包含“&”（助记修饰符）。
	 * @return 显示的文本。
	 */
	public function getDisplayText():String{
		return displayText;	
	}
	
	/**
	 * 返回助记符在显示文本中所在坐标，-1表示没有助记符。
	 * @return 助记符坐标或者 -1.
	 * @see #getDisplayText()
	 */
	public function getMnemonicIndex():int{
		return mnemonicIndex;
	}
	
	/**
	 * 返回这个按钮的键盘助记符，-1表示没有助记符。
	 * @return 键盘助记符或-1。
	 */
	public function getMnemonic():int{
		return mnemonic;
	}
	
	protected function installIcon(icon:Icon):void{
		if(icon != null && icon.getDisplay(this) != null){
			addChild(icon.getDisplay(this));
		}
	}
	
	protected function uninstallIcon(icon:Icon):void{
		var iconDis:DisplayObject = (icon == null ? null : icon.getDisplay(this));
		if(iconDis != null && isChild(iconDis)){
			removeChild(icon.getDisplay(this));
		}
	}
	
	/**
	 * 为按钮设置默认的图标。
	 * <p>
	 * 调用这个方法会使得按钮重画，但是不会重新调整布局，所以如果你设置了一个不同大小
	 * 的图标，你需要调用 <code>revalidate()</code> 来调整布局。
	 * </p>
	 * @param defaultIcon 按钮默认的图标。
	 */
	public function setIcon(defaultIcon:Icon):void{
		if(this.defaultIcon != defaultIcon){
			uninstallIcon(this.defaultIcon);
			this.defaultIcon = defaultIcon;
			installIcon(defaultIcon);
			repaint();
			invalidate();
		}
	}

	public function getIcon():Icon{
		return defaultIcon;
	}
    
    /**
	 * 返回按钮按下时的图标。
	 * @return  <code>pressedIcon</code> 属性
     * @see #setPressedIcon()
     */
    public function getPressedIcon():Icon {
        return pressedIcon;
    }
    
    /**
	 * 设置按钮按下时的图标。
	 * @param pressedIcon 这个图标用作为“按下”时的图片。
     * @see #getPressedIcon()
     */
    public function setPressedIcon(pressedIcon:Icon):void {
        var oldValue:Icon = this.pressedIcon;
        this.pressedIcon = pressedIcon;
        if (pressedIcon != oldValue) {
        	uninstallIcon(oldValue);
        	installIcon(pressedIcon);
			//if (getModel().isPressed()) {
                repaint();
            //}
        }
    }

    /**
	 * 返回按钮被选中时的图标。
	 * @return  <code>selectedIcon</code> 属性
     * @see #setSelectedIcon()
     */
    public function getSelectedIcon():Icon {
        return selectedIcon;
    }
    
    /**
	 * 设置按钮选中时的图标。
	 * @param selectedIcon 这个图标用作为“选中”时的图片。
     * @see #getSelectedIcon()
     */
    public function setSelectedIcon(selectedIcon:Icon):void {
        var oldValue:Icon = this.selectedIcon;
        this.selectedIcon = selectedIcon;
        if (selectedIcon != oldValue) {
        	uninstallIcon(oldValue);
        	installIcon(selectedIcon);
            //if (isSelected()) {
                repaint();
            //}
        }
    }

    /**
	 * 返回鼠标移上去时的图标。
	 * @return  <code>rolloverIcon</code> 属性
     * @see #setRollOverIcon()
     */
    public function getRollOverIcon():Icon {
        return rolloverIcon;
    }
    
    /**
	 * 设置鼠标移上去时的图标。
	 * @param rolloverIcon 这个图标用作为“鼠标移上”时的图片。
     * @see #getRollOverIcon()
     */
    public function setRollOverIcon(rolloverIcon:Icon):void {
        var oldValue:Icon = this.rolloverIcon;
        this.rolloverIcon = rolloverIcon;
        setRollOverEnabled(true);
        if (rolloverIcon != oldValue) {
        	uninstallIcon(oldValue);
        	installIcon(rolloverIcon);
			//if(getModel().isRollOver()){
            	repaint();
            //}
        }
      
    }
    
    /**
	 * 返回按钮被选中时鼠标移上后的图标。
	 * @return  <code>rolloverSelectedIcon</code> 属性
     * @see #setRollOverSelectedIcon()
     */
    public function getRollOverSelectedIcon():Icon {
        return rolloverSelectedIcon;
    }
    
    /**
	 * 设置按钮被选中时鼠标移上后的图标。
	 * @param rolloverSelectedIcon 这个图标用作为“被选中后鼠标移上”时的图片。
     * @see #getRollOverSelectedIcon()
     */
    public function setRollOverSelectedIcon(rolloverSelectedIcon:Icon):void {
        var oldValue:Icon = this.rolloverSelectedIcon;
        this.rolloverSelectedIcon = rolloverSelectedIcon;
        setRollOverEnabled(true);
        if (rolloverSelectedIcon != oldValue) {
        	uninstallIcon(oldValue);
        	installIcon(rolloverSelectedIcon);
            //if (isSelected()) {
                repaint();
            //}
        }
    }
    
    /**
	 * 返回按钮禁用时的图标，如果没有设置此图标，
	 * 按钮会根据默认的图标构建一个。
	 * <p>
	 * 禁用时的图标会被L&F创建（如果需要的话）。
	 * @return  <code>disabledIcon</code> 属性
     * @see #getPressedIcon()
     * @see #setDisabledIcon()
     */
    public function getDisabledIcon():Icon {
        if(disabledIcon == null) {
            if(defaultIcon != null) {
            	//TODO imp with UIResource??
                //return new GrayFilteredIcon(defaultIcon);
                return defaultIcon;
            }
        }
        return disabledIcon;
    }
    
    /**
	 * 设置按钮禁用时的图标。
	 * @param disabledIcon 这个图标在按钮作为禁用时的图片。
     * @see #getDisabledIcon()
     */
    public function setDisabledIcon(disabledIcon:Icon):void {
        var oldValue:Icon = this.disabledIcon;
        this.disabledIcon = disabledIcon;
        if (disabledIcon != oldValue) {
        	uninstallIcon(oldValue);
        	installIcon(disabledIcon);
            //if (!isEnabled()) {
                repaint();
            //}
        }
    }
    
    /**
	 * 返回按钮在禁用且被选中时的图标。如果没有设置此图标，按钮将会根据
	 * 选中时的图标来构建一个。
	 * <p>
	 * 禁用且被选中时的图标会被L&F创建。（如果需要的话）
	 * @return  <code>disabledSelectedIcon</code> 属性
     * @see #getPressedIcon()
     * @see #setDisabledIcon()
     */
    public function getDisabledSelectedIcon():Icon {
        if(disabledSelectedIcon == null) {
            if(selectedIcon != null) {
            	//TODO imp with UIResource??
                //disabledSelectedIcon = new GrayFilteredIcon(selectedIcon);
            } else {
                return getDisabledIcon();
            }
        }
        return disabledSelectedIcon;
    }

    /**
	 * 设置按钮禁用并被选中时的图标。
	 * @param disabledSelectedIcon 此按钮被用作为按钮禁用并被选中时的图片。
     * @see #getDisabledSelectedIcon()
     */
    public function setDisabledSelectedIcon(disabledSelectedIcon:Icon):void {
        var oldValue:Icon = this.disabledSelectedIcon;
        this.disabledSelectedIcon = disabledSelectedIcon;
        if (disabledSelectedIcon != oldValue) {
        	uninstallIcon(oldValue);
        	installIcon(disabledSelectedIcon);
            //if (!isEnabled() && isSelected()) {
                repaint();
                revalidate();
            //}
        }
    }

    /**
	 * 返回文本和图标在垂直方向上的对齐方式。
	 * @return  <code>verticalAlignment</code> 属性，
     * <ul>
     * <li>AsWingConstants.CENTER （默认）
     * <li>AsWingConstants.TOP
     * <li>AsWingConstants.BOTTOM
     * </ul>
     */
    public function getVerticalAlignment():int {
        return verticalAlignment;
    }
    
    /**
	 * 设置文本和图标的垂直对齐方式。
	 * @param alignment  为以下这些值之一：
     * <ul>
     * <li>AsWingConstants.CENTER （默认）
     * <li>AsWingConstants.TOP
     * <li>AsWingConstants.BOTTOM
     * </ul>
     */
    public function setVerticalAlignment(alignment:int):void {
        if (alignment == verticalAlignment){
        	return;
        }else{
        	verticalAlignment = alignment;
        	repaint();
        }
    }
    
    /**
	 * 返回图标和文本的水平对齐方式。
	 * @return  <code>horizontalAlignment</code> 属性,
     *		为以下这些值之一：
     * <ul>
     * <li>AsWingConstants.RIGHT （默认）
     * <li>AsWingConstants.LEFT
     * <li>AsWingConstants.CENTER
     * </ul>
     */
    public function getHorizontalAlignment():int{
        return horizontalAlignment;
    }
    
    /**
	 * 设置图标和文本的水平对齐方式。
	 * @param alignment  为以下这些值之一：
     * <ul>
     * <li>AsWingConstants.RIGHT （默认）
     * <li>AsWingConstants.LEFT
     * <li>AsWingConstants.CENTER
     * </ul>
     */
    public function setHorizontalAlignment(alignment:int):void {
        if (alignment == horizontalAlignment){
        	return;
        }else{
        	horizontalAlignment = alignment;     
        	repaint();
        }
    }

    
    /**
	 * 返回文本相对于图标在垂直方向上的位置。
	 * @return  <code>verticalTextPosition</code> 属性, 
     *		为以下这些值之一：
     * <ul>
     * <li>AsWingConstants.CENTER  （默认）
     * <li>AsWingConstants.TOP
     * <li>AsWingConstants.BOTTOM
     * </ul>
     */
    public function getVerticalTextPosition():int{
        return verticalTextPosition;
    }
    
    /**
	 * 设置文本相对于图标在垂直方向上的位置。
	 * @param alignment  为一些这些值之一：
     * <ul>
     * <li>AsWingConstants.CENTER （默认）
     * <li>AsWingConstants.TOP
     * <li>AsWingConstants.BOTTOM
     * </ul>
     */
    public function setVerticalTextPosition(textPosition:int):void {
        if (textPosition == verticalTextPosition){
	        return;
        }else{
        	verticalTextPosition = textPosition;
        	repaint();
        	revalidate();
        }
    }
    
    /**
	 * 返回文本相对于图标在水平方向上的位置。
     * @return  <code>horizontalTextPosition</code> 属性, 
     * 		为以下这些值之一：
     * <ul>
     * <li>AsWingConstants.RIGHT （默认）
     * <li>AsWingConstants.LEFT
     * <li>AsWingConstants.CENTER
     * </ul>
     */
    public function getHorizontalTextPosition():int {
        return horizontalTextPosition;
    }
    
    /**
	 * 设置文本相对于图标在水平方向上的位置。
	 * @param textPosition 为以下这些值之一：
     * <ul>
     * <li>AsWingConstants.RIGHT （默认）
     * <li>AsWingConstants.LEFT
     * <li>AsWingConstants.CENTER
     * </ul>
     */
    public function setHorizontalTextPosition(textPosition:int):void {
        if (textPosition == horizontalTextPosition){
        	return;
        }else{
        	horizontalTextPosition = textPosition;
        	repaint();
        	revalidate();
        }
    }
    
    /**
	 * 返回按钮中文本与图标之间的空白数量。
	 * @return 文本与图标之间的像素值。
     * @see #setIconTextGap()
     */
    public function getIconTextGap():int {
        return iconTextGap;
    }

    /**
	 * 如果图标与文本属性都设置过的话，这个属性定义它们之间的空白部分。
	 * <p>
	 * 这个属性的默认值是4个像素。
	 * 
	 * @see #getIconTextGap()
     */
    public function setIconTextGap(iconTextGap:int):void {
        var oldValue:int = this.iconTextGap;
        this.iconTextGap = iconTextGap;
        if (iconTextGap != oldValue) {
            revalidate();
            repaint();
        }
    }
    
    /**
	 * 返回当鼠标按下时，按钮中文本与图标出现位置偏移量。
	 * 
	 * @return 鼠标按下时，按钮中文本与图标出现位置偏移量。
     */
    public function getShiftOffset():int {
        return shiftOffset;
    }

    /**
	 * 设置鼠标按下时，按钮中文本与图标出现位置偏移量。
     */
    public function setShiftOffset(shiftOffset:int):void {
        var oldValue:int = this.shiftOffset;
        this.shiftOffset = shiftOffset;
        setShiftOffsetSet(true);
        if (shiftOffset != oldValue) {
            revalidate();
            repaint();
        }
    }
    
    /**
	 * 返回是否由用户来设置了shiftOffset。如果返回true的话LAF将不会改变shiftOffset。
     */
    public function isShiftOffsetSet():Boolean{
    	return shiftOffsetSet;
    }
    
   /**
	* 设置是否由用户来设置shiftOffset。如果为true LAF将不会改变shiftOffset。
    */
    public function setShiftOffsetSet(b:Boolean):void{
    	shiftOffsetSet = b;
    }
    
    //--------------------------------------------------------------
    //			internal handlers
    //--------------------------------------------------------------
	
	private function initSelfHandlers():void{
		addEventListener(MouseEvent.ROLL_OUT, __rollOutListener);
		addEventListener(MouseEvent.ROLL_OVER, __rollOverListener);
		addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownListener);
		//addEventListener(MouseEvent.MOUSE_UP, __mouseUpListener);
		addEventListener(ReleaseEvent.RELEASE, __mouseReleaseListener);
		addEventListener(Event.ADDED_TO_STAGE, __addedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, __removedFromStage);
	}
	
	private var rootPane:JRootPane;
	private function __addedToStage(e:Event):void{
		rootPane = getRootPaneAncestor();
		if(rootPane != null){
			rootPane.registerMnemonic(this);
		}
	}
	private function __removedFromStage(e:Event):void{
		if(rootPane != null){
			rootPane.unregisterMnemonic(this);
			rootPane = null;
		}
	}
	
	private function __rollOverListener(e:MouseEvent):void{
		var m:ButtonModel = getModel();
		if(isRollOverEnabled()) {
			if(m.isPressed() || !e.buttonDown){
				m.setRollOver(true);
			}
		}
		if(m.isPressed()){
			m.setArmed(true);
		}
	}
	private function __rollOutListener(e:MouseEvent):void{
		var m:ButtonModel = getModel();
		if(isRollOverEnabled()) {
			if(!m.isPressed()){
				m.setRollOver(false);
			}
		}
		m.setArmed(false);
	}
	private function __mouseDownListener(e:Event):void{
		getModel().setArmed(true);
		getModel().setPressed(true);
	}
	private function __mouseUpListener(e:Event):void{
		if(isRollOverEnabled()) {
			getModel().setRollOver(true);
		}
	}
	private function __mouseReleaseListener(e:Event):void{
		getModel().setPressed(false);
		getModel().setArmed(false);
		if(isRollOverEnabled() && !hitTestMouse()){
			getModel().setRollOver(false);
		}
	}
	
	private function __modelActionListener(e:AWEvent):void{
		dispatchEvent(new AWEvent(AWEvent.ACT));
	}
	
	private function __modelStateListener(e:AWEvent):void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
	}
	
	private function __modelSelectionListener(e:AWEvent):void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED));
	}
	
}

}