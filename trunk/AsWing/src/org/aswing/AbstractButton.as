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
 * ����ťģ��ִ�ж���ʱ�ַ����¼���ͨ������������û������ť���ߵ��� <code>doClick()</code> ������
 * @eventType org.aswing.event.AWEvent.ACT
 * @see org.aswing.AbstractButton#addActionListener()
 */
[Event(name="act", type="org.aswing.event.AWEvent")]

/**
 * ����ť��״̬�����ı�ʱ�ַ����¼�����������Щ״̬��
 * <ul>
 * <li>����</li>
 * <li>��꾭��</li>
 * <li>��갴��</li>
 * <li>����ͷ�</li>
 * <li>��ѡ��</li>
 * </ul>
 * </p>
 * <p>
 * ��ť���Ǵ��� <code>programmatic=false</code> InteractiveEvent.
 * </p>
 * @eventType org.aswing.event.InteractiveEvent.STATE_CHANGED
 */
[Event(name="stateChanged", type="org.aswing.event.InteractiveEvent")]
	
/**
 *  ��ť��ѡ��״̬���ı�ʱ�������¼���
 * <p>
 * ��ť���Ǵ��� <code>programmatic=false</code> InteractiveEvent.
 * </p>
 *  @eventType org.aswing.event.InteractiveEvent.SELECTION_CHANGED
 */
[Event(name="selectionChanged", type="org.aswing.event.InteractiveEvent")]

/**
 * ���尴ť�Ͳ˵����ͨ����Ϊ��
 * @author iiley
 */
public class AbstractButton extends Component{
	
	/**
	 * һ�ֿ��ٷ���AsWingConstants��CENTER�����ķ�ʽ
	 * @see org.aswing.AsWingConstants
	 */
	public static const CENTER:int  = AsWingConstants.CENTER;
	/**
	 * һ�ֿ��ٷ���AsWingConstants��TOP�����ķ�ʽ
	 * @see org.aswing.AsWingConstants
	 */
	public static const TOP:int     = AsWingConstants.TOP;
	/**
	 * һ�ֿ��ٷ���AsWingConstants��LEFT�����ķ�ʽ
	 * @see org.aswing.AsWingConstants
	 */
    public static const LEFT:int    = AsWingConstants.LEFT;
	/**
	 * һ�ֿ��ٷ���AsWingConstants��BOTTOM�����ķ�ʽ
	 * @see org.aswing.AsWingConstants
	 */
    public static const BOTTOM:int  = AsWingConstants.BOTTOM;
 	/**
	 * һ�ֿ��ٷ���AsWingConstants��RIGHT�����ķ�ʽ
	 * @see org.aswing.AsWingConstants
	 */
    public static const RIGHT:int   = AsWingConstants.RIGHT;
	/**
	 * һ�ֿ��ٷ���AsWingConstants��HORIZONTAL�����ķ�ʽ
	 * @see org.aswing.AsWingConstants
	 */        
	public static const HORIZONTAL:int = AsWingConstants.HORIZONTAL;
	/**
	 * һ�ֿ��ٷ���AsWingConstants��VERTICAL�����ķ�ʽ
	 * @see org.aswing.AsWingConstants
	 */
	public static const VERTICAL:int   = AsWingConstants.VERTICAL;	
	

    /** 
    ȷ����ť״̬������ģ�͡�
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
     * ���ر�ʾ�˰�ť��ģ�͡�
     * @return <code>model</code> ����
     * @see #setModel()
     */
    public function getModel():ButtonModel{
        return model;
    }
    
    /**
     * ���ñ�ʾ�˰�ť��ģ�͡�
     * @param m �µ� <code>ButtonModel</code>
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
     * �� UI ��������Ϊ��ǰ����е�һ��ֵ��
     * AbstractButton ��������Ӧ����д�˷��������� UI��
     * ���磬JButton ����ִ�����²�����
     * <pre>
     *      setUI(ButtonUI(UIManager.getUI(this)));
     * </pre>
     */
    override public function updateUI():void{
    	throw new ImpMissError();
    }
    
    /**
     * ͨ�����������ִ��һ��"����"��
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
     * ��һ�� ActionListener ��ӵ���ť�С����û������ť��ʱ��ᴥ��һ�ζ����¼���
	 * @param listener ������
	 * @param priority ���ȼ�
	 * @param useWeakReference ���������������÷�ʽ��ǿ���û��������á�
	 * @see org.aswing.event.AWEvent#ACT
     */
    public function addActionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void{
    	addEventListener(AWEvent.ACT, listener, false, priority, useWeakReference);
    }
	/**
	 * ɾ��һ����������
	 * @param listener ��ɾ���ļ�������
	 * @see org.aswing.event.AWEvent#ACT
	 */
	public function removeActionListener(listener:Function):void{
		removeEventListener(AWEvent.ACT, listener);
	}    
    	
	/**
	 * ���Ӷ԰�ťѡ��״̬�ı���¼�����������ťѡ��״̬�ı�ʱ����ѡ��
	 * ��ʧȥѡ��״̬ʱ������
	 * @param listener ������
	 * @param priority ���ȼ�
	 * @param useWeakReference ���������������÷�ʽ��ǿ���û��������á�
	 * @see org.aswing.event.InteractiveEvent#SELECTION_CHANGED
	 */	
	public function addSelectionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void{
		addEventListener(InteractiveEvent.SELECTION_CHANGED, listener, false, priority);
	}

	/**
	 * ɾ��һ��ѡ���¼���������
	 * @param listener ��ɾ���ļ�������
	 * @see org.aswing.event.InteractiveEvent#SELECTION_CHANGED
	 */
	public function removeSelectionListener(listener:Function):void{
		removeEventListener(InteractiveEvent.SELECTION_CHANGED, listener);
	}
	
	/**
	 * ���Ӷ԰�ť״̬�ı���¼���
	 * <p>
	 * ����ť��״̬�ı䣬��������Щ״̬��
	 * <ul>
	 * <li>����</li>
	 * <li>��꾭��</li>
	 * <li>��갴��</li>
	 * <li>����ͷ�</li>
	 * <li>��ѡ��</li>
	 * </ul>
	 * </p>
	 * @param listener ������
	 * @param priority ���ȼ�
	 * @param useWeakReference ���������������÷�ʽ��ǿ���û��������á�
	 * @see org.aswing.event.InteractiveEvent#STATE_CHANGED
	 */	
	public function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void{
		addEventListener(InteractiveEvent.STATE_CHANGED, listener, false, priority);
	}	
	
	/**
	 * ɾ��״̬��������
	 * @param listener ��ɾ���ļ�������
	 * @see org.aswing.event.InteractiveEvent#STATE_CHANGED
	 */	
	public function removeStateListener(listener:Function):void{
		removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
	}
	
    /**
	 * ��ť���ã����߽��ã�
	 * @param b  true Ϊ����, ����Ϊ false
     */
	override public function setEnabled(b:Boolean):void{
		if (!b && model.isRollOver()) {
	    	model.setRollOver(false);
		}
        super.setEnabled(b);
        model.setEnabled(b);
    }    

    /**
	 * ���ذ�ť��״̬��Ϊtrueʱ���ذ�ť��ѡ�У�falseʱδ��ѡ�С�
	 * @return trueʱ���ذ�ť��ѡ��, ����Ϊfalse
     */
    public function isSelected():Boolean{
        return model.isSelected();
    }
    
    /**
	 * ���ð�ť��״̬��ע�⣬����������ᴥ���¼���
	 * ���� <code>click</code> �����򻯵�ִ��һ�ζ����ı䡣
	 * @param b  �����ť��ѡ��Ϊtrue������Ϊfalse
     */
    public function setSelected(b:Boolean):void{
        model.setSelected(b);
    }
    
    /**
	 * ���� <code>rolloverEnabled</code> ���ԣ�ֻ�е������ó�
	 * <code>true</code> ��ʱ����꾭��Ч�����ܷ�����
	 * <code>rolloverEnabled</code> Ĭ������Ϊ <code>false</code>��
	 * һЩ��ۿ���û��ʵ����꾭��ʱ��Ч�������ǻ����������ԡ�
	 * @param b ���Ϊ <code>true</code>�� ��꾭��ʱ����Ч����
     * @see #isRollOverEnabled()
     */
    public function setRollOverEnabled(b:Boolean):void{
    	if(rolloverEnabled != b){
    		rolloverEnabled = b;
    		repaint();
    	}
    }
    
    /**
	 * �õ� <code>rolloverEnabled</code> ���ԡ�
	 * 
	 * @return <code>rolloverEnabled</code> ����ֵ
     * @see #setRollOverEnabled()
     */    
    public function isRollOverEnabled():Boolean{
    	return rolloverEnabled;
    }

	/**
	 * ���ð�ť�߿�ͱ�ǩ֮��Ŀհס����ÿհ�����Ϊ <code>null</code> ����ɰ�ťʹ��Ĭ�Ͽհס�
	 * ��ť��Ĭ�� <code>Border</code> ����ʹ�ø�ֵ�������ʵ��Ŀհס�
	 * ����������ڰ�ť�����÷�Ĭ�ϱ߿�
	 * ���� <code>Border</code> �����𴴽��ʵ��Ŀհף���������Խ������ԣ���
	 * 
	 * @param m �߿�ͱ�ǩ֮��Ŀհ�
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
	 * ��װһ��SimpleButton��Ϊ��ť����ۡ�
	 * @param btn ����װ��SimpleButton��
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
	 * �������ı���ʱ�����ı��м���һ����&�����������η��������磬����������ı�
	 * ������Ϊ��&File������ʾ��ʱ���ǡ�File������F���������Ƿ���
	 * <p>
	 * ���������ʹ�ð�ť�ػ������ǲ������µ������֣����������Ϊ�ı������˲�ͬ�������С��
	 * ����Ҫ���� <code>revalidate()</code> �����½��в��ֵ�����
	 * </p>
	 * @param text ��ť���ı�
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
	 * �����ı���������&�����������η�����
	 * @return �ı���
	 * @see #getDisplayText()
	 */
	public function getText():String{
		return text;
	}
	
	/**
	 * ������ʾ�ı�������ı���������&�����������η�����
	 * @return ��ʾ���ı���
	 */
	public function getDisplayText():String{
		return displayText;	
	}
	
	/**
	 * �������Ƿ�����ʾ�ı����������꣬-1��ʾû�����Ƿ���
	 * @return ���Ƿ�������� -1.
	 * @see #getDisplayText()
	 */
	public function getMnemonicIndex():int{
		return mnemonicIndex;
	}
	
	/**
	 * ���������ť�ļ������Ƿ���-1��ʾû�����Ƿ���
	 * @return �������Ƿ���-1��
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
	 * Ϊ��ť����Ĭ�ϵ�ͼ�ꡣ
	 * <p>
	 * �������������ʹ�ð�ť�ػ������ǲ������µ������֣����������������һ����ͬ��С
	 * ��ͼ�꣬����Ҫ���� <code>revalidate()</code> ���������֡�
	 * </p>
	 * @param defaultIcon ��ťĬ�ϵ�ͼ�ꡣ
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
	 * ���ذ�ť����ʱ��ͼ�ꡣ
	 * @return  <code>pressedIcon</code> ����
     * @see #setPressedIcon()
     */
    public function getPressedIcon():Icon {
        return pressedIcon;
    }
    
    /**
	 * ���ð�ť����ʱ��ͼ�ꡣ
	 * @param pressedIcon ���ͼ������Ϊ�����¡�ʱ��ͼƬ��
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
	 * ���ذ�ť��ѡ��ʱ��ͼ�ꡣ
	 * @return  <code>selectedIcon</code> ����
     * @see #setSelectedIcon()
     */
    public function getSelectedIcon():Icon {
        return selectedIcon;
    }
    
    /**
	 * ���ð�ťѡ��ʱ��ͼ�ꡣ
	 * @param selectedIcon ���ͼ������Ϊ��ѡ�С�ʱ��ͼƬ��
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
	 * �����������ȥʱ��ͼ�ꡣ
	 * @return  <code>rolloverIcon</code> ����
     * @see #setRollOverIcon()
     */
    public function getRollOverIcon():Icon {
        return rolloverIcon;
    }
    
    /**
	 * �����������ȥʱ��ͼ�ꡣ
	 * @param rolloverIcon ���ͼ������Ϊ��������ϡ�ʱ��ͼƬ��
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
	 * ���ذ�ť��ѡ��ʱ������Ϻ��ͼ�ꡣ
	 * @return  <code>rolloverSelectedIcon</code> ����
     * @see #setRollOverSelectedIcon()
     */
    public function getRollOverSelectedIcon():Icon {
        return rolloverSelectedIcon;
    }
    
    /**
	 * ���ð�ť��ѡ��ʱ������Ϻ��ͼ�ꡣ
	 * @param rolloverSelectedIcon ���ͼ������Ϊ����ѡ�к�������ϡ�ʱ��ͼƬ��
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
	 * ���ذ�ť����ʱ��ͼ�꣬���û�����ô�ͼ�꣬
	 * ��ť�����Ĭ�ϵ�ͼ�깹��һ����
	 * <p>
	 * ����ʱ��ͼ��ᱻL&F�����������Ҫ�Ļ�����
	 * @return  <code>disabledIcon</code> ����
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
	 * ���ð�ť����ʱ��ͼ�ꡣ
	 * @param disabledIcon ���ͼ���ڰ�ť��Ϊ����ʱ��ͼƬ��
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
	 * ���ذ�ť�ڽ����ұ�ѡ��ʱ��ͼ�ꡣ���û�����ô�ͼ�꣬��ť�������
	 * ѡ��ʱ��ͼ��������һ����
	 * <p>
	 * �����ұ�ѡ��ʱ��ͼ��ᱻL&F�������������Ҫ�Ļ���
	 * @return  <code>disabledSelectedIcon</code> ����
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
	 * ���ð�ť���ò���ѡ��ʱ��ͼ�ꡣ
	 * @param disabledSelectedIcon �˰�ť������Ϊ��ť���ò���ѡ��ʱ��ͼƬ��
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
	 * �����ı���ͼ���ڴ�ֱ�����ϵĶ��뷽ʽ��
	 * @return  <code>verticalAlignment</code> ���ԣ�
     * <ul>
     * <li>AsWingConstants.CENTER ��Ĭ�ϣ�
     * <li>AsWingConstants.TOP
     * <li>AsWingConstants.BOTTOM
     * </ul>
     */
    public function getVerticalAlignment():int {
        return verticalAlignment;
    }
    
    /**
	 * �����ı���ͼ��Ĵ�ֱ���뷽ʽ��
	 * @param alignment  Ϊ������Щֵ֮һ��
     * <ul>
     * <li>AsWingConstants.CENTER ��Ĭ�ϣ�
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
	 * ����ͼ����ı���ˮƽ���뷽ʽ��
	 * @return  <code>horizontalAlignment</code> ����,
     *		Ϊ������Щֵ֮һ��
     * <ul>
     * <li>AsWingConstants.RIGHT ��Ĭ�ϣ�
     * <li>AsWingConstants.LEFT
     * <li>AsWingConstants.CENTER
     * </ul>
     */
    public function getHorizontalAlignment():int{
        return horizontalAlignment;
    }
    
    /**
	 * ����ͼ����ı���ˮƽ���뷽ʽ��
	 * @param alignment  Ϊ������Щֵ֮һ��
     * <ul>
     * <li>AsWingConstants.RIGHT ��Ĭ�ϣ�
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
	 * �����ı������ͼ���ڴ�ֱ�����ϵ�λ�á�
	 * @return  <code>verticalTextPosition</code> ����, 
     *		Ϊ������Щֵ֮һ��
     * <ul>
     * <li>AsWingConstants.CENTER  ��Ĭ�ϣ�
     * <li>AsWingConstants.TOP
     * <li>AsWingConstants.BOTTOM
     * </ul>
     */
    public function getVerticalTextPosition():int{
        return verticalTextPosition;
    }
    
    /**
	 * �����ı������ͼ���ڴ�ֱ�����ϵ�λ�á�
	 * @param alignment  ΪһЩ��Щֵ֮һ��
     * <ul>
     * <li>AsWingConstants.CENTER ��Ĭ�ϣ�
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
	 * �����ı������ͼ����ˮƽ�����ϵ�λ�á�
     * @return  <code>horizontalTextPosition</code> ����, 
     * 		Ϊ������Щֵ֮һ��
     * <ul>
     * <li>AsWingConstants.RIGHT ��Ĭ�ϣ�
     * <li>AsWingConstants.LEFT
     * <li>AsWingConstants.CENTER
     * </ul>
     */
    public function getHorizontalTextPosition():int {
        return horizontalTextPosition;
    }
    
    /**
	 * �����ı������ͼ����ˮƽ�����ϵ�λ�á�
	 * @param textPosition Ϊ������Щֵ֮һ��
     * <ul>
     * <li>AsWingConstants.RIGHT ��Ĭ�ϣ�
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
	 * ���ذ�ť���ı���ͼ��֮��Ŀհ�������
	 * @return �ı���ͼ��֮�������ֵ��
     * @see #setIconTextGap()
     */
    public function getIconTextGap():int {
        return iconTextGap;
    }

    /**
	 * ���ͼ�����ı����Զ����ù��Ļ���������Զ�������֮��Ŀհײ��֡�
	 * <p>
	 * ������Ե�Ĭ��ֵ��4�����ء�
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
	 * ���ص���갴��ʱ����ť���ı���ͼ�����λ��ƫ������
	 * 
	 * @return ��갴��ʱ����ť���ı���ͼ�����λ��ƫ������
     */
    public function getShiftOffset():int {
        return shiftOffset;
    }

    /**
	 * ������갴��ʱ����ť���ı���ͼ�����λ��ƫ������
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
	 * �����Ƿ����û���������shiftOffset���������true�Ļ�LAF������ı�shiftOffset��
     */
    public function isShiftOffsetSet():Boolean{
    	return shiftOffsetSet;
    }
    
   /**
	* �����Ƿ����û�������shiftOffset�����Ϊtrue LAF������ı�shiftOffset��
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