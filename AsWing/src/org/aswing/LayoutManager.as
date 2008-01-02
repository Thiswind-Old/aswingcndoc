/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing
{
	
import org.aswing.geom.IntDimension;	
	
/** 
 * 为约器基于的布局约束对象所属的类定义接口。
 *
 * @see Component
 * @see Container
 *
 * @author 	iiley
 */
public interface LayoutManager
{
    /**
     * 添加指定组件到布局中，并指定约束对象。
     * @param comp 要被添加的组件
     * @param constraints  组件被添加到布局中的 位置/方式
     */
    function addLayoutComponent(comp:Component, constraints:Object):void;

    /**
     * 从布局中删除指定的组件。
     * @param comp 要被删除的组件
     */
    function removeLayoutComponent(comp:Component):void;

    /**
     * 为指定的容器计算容纳组件的最佳尺寸。
     * @param target 要布置的容器
     *  
     * @see #minimumLayoutSize
     */
    function preferredLayoutSize(target:Container):IntDimension;

    /** 
     * 为指定的容器计算容纳组件的最小尺寸。
     * @param target 要布置的容器
     * @see #preferredLayoutSize
     */
    function minimumLayoutSize(target:Container):IntDimension;

    /** 
     * 为指定的容器计算容纳组件的最大尺寸。
     * @param target  要布置的容器
     * @see #preferredLayoutSize
     */
    function maximumLayoutSize(target:Container):IntDimension;
    
    /** 
     * 布置指定容器。
     * @param target 要布置的容器
     */
    function layoutContainer(target:Container):void;

    /**
     * 返回沿 X 轴的对齐方式。它指定如何相对于其他组件对齐该组件。
     * 值应该是一个介于 0 和 1 之间的数，其中 0 表示顶部对齐，1 表示底部对齐，0.5 表示居中对齐等。 
     */
    function getLayoutAlignmentX(target:Container):Number;

    /**
     * 返回沿 X 轴的对齐方式。它指定如何相对于其他组件对齐该组件。
     * 值应该是一个介于 0 和 1 之间的数，其中 0 表示顶部对齐，1 表示底部对齐，0.5 表示居中对齐等。 
     */
    function getLayoutAlignmentY(target:Container):Number;

    /**
     * 使布局失效，指示如果布局管理器缓存了信息，则应该将其丢弃。 
     */
    function invalidateLayout(target:Container):void;
}

}