
////////////////////////////////////////////////////////////////////////////////
// Сроки исполнения процессов вызов сервера КОРП: содержит процедуры и функции по работе
// со сроками процессов в редакциях КОРП/ДГУ.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции_КарточкиПроцессовИШаблонов

// Изменять срок (точную дату или относительный срок) по предствлению
//
// Используется для переопределения одноименной функции в модуле СрокиИсполненияПроцессовКлиент.
// Вместо текущей следует использовать функцию из модуля СрокиИсполненияПроцессовКлиент.
//
// Параметры:
//  Дата - Дата - срок исполнения датой (точный срок).
//  Дни - Число - относительный срок, дни.
//  Часы - Число - относительный срок, часы.
//  Минуты - Число - относительный срок, минуты.
//  ВариантУстановкиСрока - ПеречислениеСсылка.ВариантыУстановкиСрокаИсполнения - 
//                          вариант установки срока.
//  Представление - Строка - представление срока строкой.
//  ДопПараметры - Структура - структура вспомогательных параметров.
//   * ТекстСообщенияПредупреждения - Строка - возвращаемый текст сообщения/предупреждения в
//                                             случае ошибки.
//   * ВПредставленииМожетБытьДата - Булево - признак того, что в представлении может быть дата.
//   * Исполнитель - СправочникСсылка.Пользователи,
//                   СправочникСсылка.РолиИсполнителей - исполнитель срок которого изменяется.
//
Функция ИзменитьСрокИсполненияПоПредставлению(
	Дата, Дни, Часы, Минуты, ВариантУстановкиСрока, Представление, ДопПараметры) Экспорт
	
	// Если представление пустое, то очищаем все поля сроков
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Дата = Дата(1,1,1);
		Дни = 0;
		Часы = 0;
		Минуты = 0;
		
		Возврат Истина;
	КонецЕсли;
	
	ТекстСообщенияОбОшибке = НСтр("ru = 'Срок задан некорректно.'");
	
	ВариантыУстановкиСрока = СрокиИсполненияПроцессовКлиентСервер.ВариантыУстановкиСрокаИсполнения();
	
	// Если есть разделитель даты и длительности, тогда разделяем представление на
	// длительность (ПредставлениеДлительности) и дату (ПредставлениеДаты), иначе
	// пытаемся обработать целиком представление и как длительность и как дату.
	Представление = СтрЗаменить(Представление, ")", "");
	ПредставлениеДлительности = Представление;
	ПредставлениеДаты = Представление;
	Если ДопПараметры.ВПредставленииМожетБытьДата Тогда
		Разделитель = "(";
		
		Если СтрНайти(Представление, Разделитель) Тогда
			ЧастиПредставления = СтрРазделить(Представление, Разделитель);
			КоличествоЧастейПредствления = ЧастиПредставления.Количество();
			Если КоличествоЧастейПредствления <> 2 Тогда
				ДопПараметры.ТекстСообщенияПредупреждения = ТекстСообщенияОбОшибке;
				Возврат Ложь;
			КонецЕсли;
			
			Если ВариантУстановкиСрока = ВариантыУстановкиСрока.ТочныйСрок Тогда
				ПредставлениеДлительности = СокрЛП(ЧастиПредставления[1]);
				ПредставлениеДаты = СокрЛП(ЧастиПредставления[0]);
			Иначе
				ПредставлениеДлительности = СокрЛП(ЧастиПредставления[0]);
				ПредставлениеДаты = СокрЛП(ЧастиПредставления[1]);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	// Определяем дату по представлению.
	НоваяДата = Дата(1,1,1);
	Если ДопПараметры.ВПредставленииМожетБытьДата Тогда
		НоваяДата = СрокиИсполненияПроцессовКлиентСервер.ДатаПоПредставлению(ПредставлениеДаты);
	КонецЕсли;
	
	// Определяем длительность по представлению.
	Длительность = СрокиИсполненияПроцессовКлиентСервер.ДлительностьПоПредставлению(ПредставлениеДлительности);
	
	// Если по представлению не удалось определить ни длительность
	// ни дату, то выводим сообщение об ошибке.
	Если Не ЗначениеЗаполнено(Длительность) И Не ЗначениеЗаполнено(НоваяДата) Тогда
		ДопПараметры.ТекстСообщенияПредупреждения = ТекстСообщенияОбОшибке;
		Возврат Ложь;
	КонецЕсли;
	
	// Если удалось определить и длительность и дату,
	// и они все отличаются от предыдущих значений, тогда выводим ошибку.
	// Измененным может быть либо длительность, либо дата.
	Если ЗначениеЗаполнено(Длительность)
		И (Дни <> Длительность.Дни Или Часы <> Длительность.Часы Или Минуты <> Длительность.Минуты)
		И ЗначениеЗаполнено(НоваяДата)
		И Дата <> НоваяДата Тогда
		
		ДопПараметры.ТекстСообщенияПредупреждения = ТекстСообщенияОбОшибке;
		Возврат Ложь;
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач = 
		ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	// Установка срока исполнения по новой дате
	Если ЗначениеЗаполнено(НоваяДата) И Дата <> НоваяДата Тогда
		
		ВариантУстановкиСрока = ВариантыУстановкиСрока.ТочныйСрок;
		
		Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
			Дата = НоваяДата;
		Иначе
			Дата = Дата(Год(НоваяДата), Месяц(НоваяДата), День(НоваяДата));
			Дата = КонецДня(Дата);
		КонецЕсли;
		
		// Корректировка указанной даты по графику работ.
		Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда
			
			ГрафикРаботы = 
				СрокиИсполненияПроцессовКОРП.ГрафикРаботыУчастникаПроцесса(ДопПараметры.Исполнитель);
			
			ЭтоРабочееВремя = Истина;
			Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
				ЭтоРабочееВремя = ГрафикиРаботы.ЭтоРабочаяДатаВремя(ГрафикРаботы, Дата);
			Иначе
				ЭтоРабочееВремя = ГрафикиРаботы.ЭтоРабочийДень(Дата, ГрафикРаботы);
			КонецЕсли;
			
			Если Не ЭтоРабочееВремя Тогда
				ДопПараметры.ТекстСообщенияПредупреждения = 
					НСтр("ru = 'Выбранный срок не соответствует графику работы исполнителя.
						|Задача может быть просрочена.'");
			КонецЕсли;
			
		КонецЕсли;
		
		Дни = 0;
		Часы = 0;
		Минуты = 0;
		
	// Установка срока исполнения по новой длительности
	ИначеЕсли ЗначениеЗаполнено(Длительность)
		И (Длительность.Дни <> Дни
			Или Длительность.Часы <> Часы
			Или Длительность.Минуты <> Минуты) Тогда
		
		ВариантУстановкиСрока = ВариантыУстановкиСрока.ОтносительныйСрок;
		
		Дни = Длительность.Дни;
		Часы = Длительность.Часы;
		Минуты = Длительность.Минуты;
		
		Если Не ИспользоватьДатуИВремяВСрокахЗадач Тогда
			Часы = 0;
			Минуты = 0;
		КонецЕсли;
		
		Дата = Дата(1,1,1);
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
