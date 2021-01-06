
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбраны задачи.'"));
		Возврат;
	КонецЕсли;
		
	ОчиститьСообщения();
	Для Каждого Задача Из ПараметрКоманды Цикл
		ВыполнитьЗадачу(Задача);
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Задача выполнена'"),
			ПолучитьНавигационнуюСсылку(Задача),
			Строка(Задача));
	КонецЦикла;
	Оповестить("ЗадачаВыполнена", ПараметрКоманды);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачу(Задача)
	
	ВыполнениеЗадачСервер.ВыполнитьЗадачу(Задача, Истина);
	
КонецПроцедуры

