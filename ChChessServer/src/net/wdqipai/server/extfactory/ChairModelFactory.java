package net.wdqipai.server.extfactory;

import net.wdqipai.core.logic.*;
import net.wdqipai.core.model.*;
import net.wdqipai.server.extmodel.*;
import net.wdqipai.server.*;

//
//

public final class ChairModelFactory
{
	/** 
	 性能优化，直接 return 就行了
	 
	 @return 
	*/
	public static IChairModel Create(int id)
	{
		return new ChairModelByChChess(id);

	}
}