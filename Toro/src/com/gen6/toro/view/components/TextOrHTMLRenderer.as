package com.gen6.toro.view.components
{
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridItemRenderer;
import mx.controls.dataGridClasses.DataGridColumn;

public class TextOrHTMLRenderer extends DataGridItemRenderer
{

	public function TextOrHTMLRenderer()
	{
		super();
	}

	override public function validateProperties():void
	{
		super.validateProperties();
		if (listData)
		{
			var dg:DataGrid = DataGrid(listData.owner);

			var column:DataGridColumn =	dg.columns[listData.columnIndex];
			htmlText = data[column.dataField];

			if (getStyle("plainText"))
			{
				text = text;
			}
		}
	}

}

}