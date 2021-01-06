
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.НоменклатураКонтрагентовБЭД";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Идентификатор");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Идентификатор");

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1000
	               |	НоменклатураКонтрагентовБЭД.Владелец КАК Владелец,
	               |	НоменклатураКонтрагентовБЭД.Идентификатор КАК Идентификатор
	               |ИЗ
	               |	РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
	               |ГДЕ
	               |	(НоменклатураКонтрагентовБЭД.ИдентификаторНоменклатуры = """"
	               |			ИЛИ НоменклатураКонтрагентовБЭД.ИдентификаторХарактеристики = """"
	               |			ИЛИ НоменклатураКонтрагентовБЭД.ИдентификаторУпаковки = """")
	               |	И НоменклатураКонтрагентовБЭД.Идентификатор > &Идентификатор
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Идентификатор";
	
	ОтработаныВсеДанные = Ложь;
	Идентификатор       = "";
	
	Пока НЕ ОтработаныВсеДанные Цикл
		
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		
		Выгрузка = Запрос.Выполнить().Выгрузить();
		
		КоличествоСтрок = Выгрузка.Количество();
		
		Если КоличествоСтрок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСтрок > 0 Тогда
			Идентификатор = Выгрузка[КоличествоСтрок - 1].Идентификатор;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
		
	КонецЦикла;
	
КонецПроцедуры
	
// Обработчик обновления БЭД 1.7.1
//
// Перебирает записи в регистре сведений НоменклатураКонтрагентовБЭД и разбивает идентификатор на части:
//  Идентификатор Номенклатуры, Идентификатор Характеристики, Идентификатор Упаковки.
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НоменклатураКонтрагентовБЭД;
	ПолноеИмяОбъекта  = МетаданныеОбъекта.ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ЕстьОтработанныеЗаписи = Ложь;
	ПроизошлаОшибка        = Ложь;
	Для Каждого Строка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки       = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Владелец"     , Строка.Владелец);
			ЭлементБлокировки.УстановитьЗначение("Идентификатор", Строка.Идентификатор);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.НоменклатураКонтрагентовБЭД.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Владелец.Установить(Строка.Владелец);
			НаборЗаписей.Отбор.Идентификатор.Установить(Строка.Идентификатор);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество()
				И (НЕ ЗначениеЗаполнено(НаборЗаписей[0].ИдентификаторНоменклатуры)
				ИЛИ НЕ ЗначениеЗаполнено(НаборЗаписей[0].ИдентификаторХарактеристики)
				ИЛИ НЕ ЗначениеЗаполнено(НаборЗаписей[0].ИдентификаторУпаковки))Тогда
				
				ТекущаяЗапись = НаборЗаписей[0];
				
				ОбменСКонтрагентамиСлужебныйКлиентСервер.РазделитьИдентификаторНаЧасти(ТекущаяЗапись.Идентификатор, ТекущаяЗапись);
				
				Если ЗначениеЗаполнено(ТекущаяЗапись.Характеристика) Тогда
					ТекущаяЗапись.ИспользоватьХарактеристики = Истина;
				КонецЕсли;
					
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЕстьОтработанныеЗаписи = Истина;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать запись по идентификатору: %1 по причине:'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, Строка.Идентификатор) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, Строка.Идентификатор, ТекстСообщения);
				
			ПроизошлаОшибка = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если НЕ ЕстьОтработанныеЗаписи И ПроизошлаОшибка Тогда
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;

	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли