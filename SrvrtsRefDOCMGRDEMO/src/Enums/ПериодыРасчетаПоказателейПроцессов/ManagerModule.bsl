#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текущую дату периода расчета настроек отбора.
//
// Параметры:
//  НастройкиОтбора - Структура - Настройки отбора. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//  ДатаРасчета - Дата - Дата, на которую рассчитывается показатель.
//
// Возвращаемое значение:
//  Дата - Текущая дата периода расчета.
//
Функция ДатаПериода(НастройкиОтбора, ДатаРасчета) Экспорт
	
	ПериодРасчета = НастройкиОтбора.ПериодРасчета;
	Если Не ЗначениеЗаполнено(ПериодРасчета) Тогда
		ТекстИсключения = НСтр("ru = 'Не указан период расчета.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ДатаПериода = Дата(1, 1, 1);
	Если ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.День Тогда
		ДатаПериода = КонецДня(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Неделя Тогда
		ДатаПериода = КонецНедели(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Месяц Тогда
		ДатаПериода = КонецМесяца(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Квартал Тогда
		ДатаПериода = КонецКвартала(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Год Тогда
		ДатаПериода = КонецГода(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням Тогда
		ДатаПериода = ДатаРасчета;
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		ДатаПериода = ДатаРасчета;
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Актуальный Тогда
		ДатаПериода = ДатаРасчета;
	Иначе
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Неизвестный период расчета %1.'"), ПериодРасчета);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Возврат ДатаПериода;
	
КонецФункции

// Возвращает начало периода расчета настроек отбора.
//
// Параметры:
//  НастройкиОтбора - Структура - Настройки отбора. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//  ДатаРасчета - Дата - Дата, на которую рассчитывается показатель.
//
// Возвращаемое значение:
//  Дата - Начало периода расчета.
//
Функция НачалоПериода(НастройкиОтбора, ДатаРасчета) Экспорт
	
	ПериодРасчета = НастройкиОтбора.ПериодРасчета;
	Если Не ЗначениеЗаполнено(ПериодРасчета) Тогда
		ТекстИсключения = НСтр("ru = 'Не указан период расчета.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	НачалоПериода = Дата(1, 1, 1);
	Если ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.День Тогда
		НачалоПериода = НачалоДня(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Неделя Тогда
		НачалоПериода = НачалоНедели(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Месяц Тогда
		НачалоПериода = НачалоМесяца(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Квартал Тогда
		НачалоПериода = НачалоКвартала(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Год Тогда
		НачалоПериода = НачалоГода(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням Тогда
		НачалоПериода = НачалоДня(ДатаРасчета) - (НастройкиОтбора.ДниПериодаРасчета - 1) * 86400; // 86400 - количество секунд в дне.
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		НачалоПериода = НастройкиОтбора.НачалоПериодаРасчета;
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Актуальный Тогда
		НачалоПериода = Дата(1, 1, 1);
	Иначе
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Неизвестный период расчета %1.'"), ПериодРасчета);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Возврат НачалоПериода;
	
КонецФункции

// Возвращает окончание периода расчета настроек отбора.
//
// Параметры:
//  НастройкиОтбора - Структура - Настройки отбора. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//  ДатаРасчета - Дата - Дата, на которую рассчитывается показатель.
//
// Возвращаемое значение:
//  Дата - Окончание периода расчета.
//
Функция ОкончаниеПериода(НастройкиОтбора, ДатаРасчета) Экспорт
	
	ПериодРасчета = НастройкиОтбора.ПериодРасчета;
	Если Не ЗначениеЗаполнено(ПериодРасчета) Тогда
		ТекстИсключения = НСтр("ru = 'Не указан период расчета.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ОкончаниеПериода = Дата(1, 1, 1);
	Если ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.День Тогда
		ОкончаниеПериода = КонецДня(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Неделя Тогда
		ОкончаниеПериода = КонецНедели(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Месяц Тогда
		ОкончаниеПериода = КонецМесяца(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Квартал Тогда
		ОкончаниеПериода = КонецКвартала(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Год Тогда
		ОкончаниеПериода = КонецГода(ДатаРасчета);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням Тогда
		ОкончаниеПериода = ДатаРасчета;
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		ОкончаниеПериода = НастройкиОтбора.ОкончаниеПериодаРасчета;
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Актуальный Тогда
		ОкончаниеПериода = ДатаРасчета;
	Иначе
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Неизвестный период расчета %1.'"), ПериодРасчета);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Возврат ОкончаниеПериода;
	
КонецФункции

// Рассчитывает предыдущую дату расчета.
//
// Параметры:
//  ПериодРасчета - ПеречислениеСсылка.ПериодыРасчетаПоказателейПроцессов - Период расчета.
//  ДатаРасчета - Дата - Дата расчета.
//  ПериодЗамеров - Число - Период замеров.
// 
// Возвращаемое значение:
//  Дата - Предыдущая дата расчета.
//
Функция ПредыдущаяДатаРасчета(ПериодРасчета, ДатаРасчета, ПериодЗамеров) Экспорт
	
	Если Не ЗначениеЗаполнено(ПериодРасчета) Тогда
		ТекстИсключения = НСтр("ru = 'Не указан период расчета.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ПредыдущаяДатаРасчета = Дата(1, 1, 1);
	Если ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.День Тогда
		ПредыдущаяДатаРасчета = НачалоДня(НачалоДня(ДатаРасчета) - 1);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Неделя Тогда
		ПредыдущаяДатаРасчета = НачалоНедели(НачалоНедели(ДатаРасчета) - 1);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Месяц Тогда
		ПредыдущаяДатаРасчета = НачалоМесяца(НачалоМесяца(ДатаРасчета) - 1);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Квартал Тогда
		ПредыдущаяДатаРасчета = НачалоКвартала(НачалоКвартала(ДатаРасчета) - 1);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Год Тогда
		ПредыдущаяДатаРасчета = НачалоГода(НачалоГода(ДатаРасчета) - 1);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням Тогда
		ПредыдущаяДатаРасчета = НачалоЧаса(ДатаРасчета) - ПериодЗамеров * 3600;
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		ПредыдущаяДатаРасчета = Дата(1, 1, 1);
	ИначеЕсли ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.Актуальный Тогда
		ПредыдущаяДатаРасчета = НачалоЧаса(ДатаРасчета) - ПериодЗамеров * 3600;
	Иначе
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Неизвестный период расчета %1.'"), ПериодРасчета);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Возврат ПредыдущаяДатаРасчета;
	
КонецФункции

#КонецОбласти

#КонецЕсли

