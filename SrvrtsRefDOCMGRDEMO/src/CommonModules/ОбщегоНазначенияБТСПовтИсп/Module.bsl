#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание тиров, содержащее примитивные типы.
//
// Возвращаемое значение:
//   ОписаниеТипов - описание.
//
Функция ОписаниеПримитивныхТипов() Экспорт
	
	Возврат Новый ОписаниеТипов("Число, Строка, Булево, Дата, УникальныйИдентификатор, ОписаниеТипов");
	
КонецФункции

// Возвращает описание типов, содержащее все ссылочные типы объектов метаданных, существующих
// в конфигурации.
//
// Возвращаемое значение:
//   ОписаниеТипов - описание.
//
Функция ОписаниеСсылочныхТипов() Экспорт
	
	ОписаниеТипаЛюбаяСсылкаXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://v8.1c.ru/8.1/data/core", "TypeDescription"));
	ОписаниеТипаЛюбаяСсылкаXDTO.TypeSet.Добавить(СериализаторXDTO.ЗаписатьXDTO(Новый РасширенноеИмяXML(
		"http://v8.1c.ru/8.1/data/enterprise/current-config", "AnyRef")));
	ОписаниеТипаЛюбаяСсылка = СериализаторXDTO.ПрочитатьXDTO(ОписаниеТипаЛюбаяСсылкаXDTO);
	
	Возврат ОписаниеТипаЛюбаяСсылка;
	
КонецФункции

// Возвращает ссылки точек маршрута бизнес-процессов.
//
// Возвращаемое значение:
//   ФиксированноеСоответствие - с полями:
//    * Ключ - Тип - тип ТочкаМаршрутаБизнесПроцессаСсылка,
//    * Значение - Строка - имя бизнес-процесса.
//
Функция СсылкиТочекМаршрутаБизнесПроцессов() Экспорт
	
	СсылкиТочекМаршрутаБизнесПроцессов = Новый Соответствие();
	Для Каждого БизнесПроцесс Из Метаданные.БизнесПроцессы Цикл
		СсылкиТочекМаршрутаБизнесПроцессов.Вставить(Тип("ТочкаМаршрутаБизнесПроцессаСсылка." + БизнесПроцесс.Имя), БизнесПроцесс.Имя);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СсылкиТочекМаршрутаБизнесПроцессов);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
// 	ФиксированноеСоответствие
//
Функция ОписаниеМоделиДанныхКонфигурации() Экспорт
	
	Модель = Новый Соответствие();
	
	ЗаполнитьМодельПоПодсистемам(Модель);
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ПараметрыСеанса");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ОбщиеРеквизиты");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ПланыОбмена");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "РегламентныеЗадания");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "Константы");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "Справочники");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "Документы");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "Последовательности");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ЖурналыДокументов");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "Перечисления");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ПланыВидовХарактеристик");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ПланыСчетов");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ПланыВидовРасчета");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "РегистрыСведений");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "РегистрыНакопления");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "РегистрыБухгалтерии");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "РегистрыРасчета");
	ЗаполнитьМодельПоПерерасчетам(Модель);
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "БизнесПроцессы");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "Задачи");
	ЗаполнитьМодельПоКоллекцииМетаданных(Модель, "ВнешниеИсточникиДанных");
	ЗаполнитьМодельПоФункциональнымОпциям(Модель);
	ЗаполнитьМодельПоРазделителям(Модель);
	
	Возврат ФиксироватьМодель(Модель);
	
КонецФункции

// Возвращаемое значение:
// 	ФиксированнаяСтруктура - Описание:
// * ВнешниеИсточникиДанных - Число -
// * РегламентныеЗадания - Число -
// * Перерасчеты - Число -
// * РегистрыРасчета - Число -
// * РегистрыБухгалтерии - Число -
// * РегистрыНакопления - Число -
// * РегистрыСведений - Число -
// * Последовательности - Число -
// * ЖурналыДокументов - Число -
// * ПланыОбмена - Число -
// * Задачи - Число -
// * БизнесПроцессы - Число -
// * ПланыВидовРасчета - Число -
// * ПланыСчетов - Число -
// * ПланыВидовХарактеристик - Число -
// * Перечисления - Число -
// * Документы - Число -
// * Справочники - Число -
// * Константы - Число -
// * ОбщиеРеквизиты - Число -
// * ПараметрыСеанса - Число -
// * Подсистемы - Число -
Функция КлассыМетаданныхВМоделиКонфигурации() Экспорт
	
	ТекущиеКлассыМетаданных = Новый Структура();
	ТекущиеКлассыМетаданных.Вставить("Подсистемы", 1);
	ТекущиеКлассыМетаданных.Вставить("ПараметрыСеанса", 2);
	ТекущиеКлассыМетаданных.Вставить("ОбщиеРеквизиты", 3);
	ТекущиеКлассыМетаданных.Вставить("Константы", 4);
	ТекущиеКлассыМетаданных.Вставить("Справочники", 5);
	ТекущиеКлассыМетаданных.Вставить("Документы", 6);
	ТекущиеКлассыМетаданных.Вставить("Перечисления", 7);
	ТекущиеКлассыМетаданных.Вставить("ПланыВидовХарактеристик", 8);
	ТекущиеКлассыМетаданных.Вставить("ПланыСчетов", 9);
	ТекущиеКлассыМетаданных.Вставить("ПланыВидовРасчета", 10);
	ТекущиеКлассыМетаданных.Вставить("БизнесПроцессы", 11);
	ТекущиеКлассыМетаданных.Вставить("Задачи", 12);
	ТекущиеКлассыМетаданных.Вставить("ПланыОбмена", 13);
	ТекущиеКлассыМетаданных.Вставить("ЖурналыДокументов", 14);
	ТекущиеКлассыМетаданных.Вставить("Последовательности", 15);
	ТекущиеКлассыМетаданных.Вставить("РегистрыСведений", 16);
	ТекущиеКлассыМетаданных.Вставить("РегистрыНакопления", 17);
	ТекущиеКлассыМетаданных.Вставить("РегистрыБухгалтерии", 18);
	ТекущиеКлассыМетаданных.Вставить("РегистрыРасчета", 19);
	ТекущиеКлассыМетаданных.Вставить("Перерасчеты", 20);
	ТекущиеКлассыМетаданных.Вставить("РегламентныеЗадания", 21);
	ТекущиеКлассыМетаданных.Вставить("ВнешниеИсточникиДанных", 22);
	
	Возврат Новый ФиксированнаяСтруктура(ТекущиеКлассыМетаданных);
	
КонецФункции

// Возвращает шаблон описания объекта для модели данных конфигурации.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * РазделениеДанных - Структура -
// * ФункциональныеОпции - Массив -
// * Зависимости - Соответствие -
// * Представление - Строка -
// * ПолноеИмя - Строка -
Функция НовыйОписаниеОбъекта() Экспорт

	ОписаниеОбъекта = Новый Структура();
	ОписаниеОбъекта.Вставить("ПолноеИмя", "");
	ОписаниеОбъекта.Вставить("Представление", "");
	ОписаниеОбъекта.Вставить("Зависимости", Новый Соответствие);
	ОписаниеОбъекта.Вставить("ФункциональныеОпции", Новый Массив);
	ОписаниеОбъекта.Вставить("РазделениеДанных", Новый Структура);

	Возврат ОписаниеОбъекта;
	
КонецФункции

Функция КлассыМетаданных()
	
	Возврат ОбщегоНазначенияБТСПовтИсп.КлассыМетаданныхВМоделиКонфигурации();
	
КонецФункции

Функция ГруппаМоделиДанных(Знач Модель, Знач Класс)
	
	Группа = Модель.Получить(Класс);
	
	Если Группа = Неопределено Тогда
		Группа = Новый Соответствие();
		Модель.Вставить(Класс, Группа);
	КонецЕсли;
	
	Возврат Группа;
	
КонецФункции

Процедура ЗаполнитьМодельПоПодсистемам(Знач Модель)
	
	ГруппаПодсистем = ГруппаМоделиДанных(Модель, КлассыМетаданных().Подсистемы);
	
	Для Каждого Подсистема Из Метаданные.Подсистемы Цикл
		ЗаполнитьМодельПоПодсистеме(ГруппаПодсистем, Подсистема);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоПодсистеме(Знач ГруппаМодели, Знач Подсистема)
	
	ЗаполнитьМодельПоОбъектуМетаданных(ГруппаМодели, Подсистема, КлассыМетаданных().Подсистемы);
	
	Для Каждого ВложеннаяПодсистема Из Подсистема.Подсистемы Цикл
		ЗаполнитьМодельПоПодсистеме(ГруппаМодели, ВложеннаяПодсистема);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоПерерасчетам(Знач Модель)
	
	ГруппаМодели = ГруппаМоделиДанных(Модель, КлассыМетаданных().Перерасчеты);
	
	Для Каждого РегистрРасчета Из Метаданные.РегистрыРасчета Цикл
		
		Для Каждого Перерасчет Из РегистрРасчета.Перерасчеты Цикл
			
			ЗаполнитьМодельПоОбъектуМетаданных(ГруппаМодели, Перерасчет, КлассыМетаданных().Перерасчеты);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоКоллекцииМетаданных(Знач Модель, Знач ИмяКоллекции)
	
	Класс = КлассыМетаданных()[ИмяКоллекции];
	ГруппаМодели = ГруппаМоделиДанных(Модель, Класс);
	
	КоллекцияМетаданных = Метаданные[ИмяКоллекции];
	Для Каждого ОбъектМетаданных Из КоллекцияМетаданных Цикл
		ЗаполнитьМодельПоОбъектуМетаданных(ГруппаМодели, ОбъектМетаданных, Класс);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоОбъектуМетаданных(Знач ГруппаМодели, Знач ОбъектМетаданных, Знач Класс)
	
	ОписаниеОбъекта = НовыйОписаниеОбъекта();
	ОписаниеОбъекта.ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	ОписаниеОбъекта.Представление = ОбъектМетаданных.Представление();
	
	ГруппаМодели.Вставить(ОбъектМетаданных.Имя, ОписаниеОбъекта);
	
	ЗаполнитьМодельПоЗависимостямОбъектаМетаданных(ОписаниеОбъекта.Зависимости, ОбъектМетаданных, Класс);
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоЗависимостямОбъектаМетаданных(Знач ЗависимостиОбъекта, Знач ОбъектМетаданных, Знач Класс)
	
	Если Класс = КлассыМетаданных().Константы Тогда
		
		ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, ОбъектМетаданных.Тип);
		
	ИначеЕсли (Класс = КлассыМетаданных().Справочники
			ИЛИ Класс = КлассыМетаданных().Документы
			ИЛИ Класс = КлассыМетаданных().ПланыВидовХарактеристик
			ИЛИ Класс = КлассыМетаданных().ПланыСчетов
			ИЛИ Класс = КлассыМетаданных().ПланыВидовРасчета
			ИЛИ Класс = КлассыМетаданных().БизнесПроцессы
			ИЛИ Класс = КлассыМетаданных().Задачи
			ИЛИ Класс = КлассыМетаданных().ПланыОбмена) Тогда
		
		// Стандартные реквизиты
		Для Каждого СтандартныйРеквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, СтандартныйРеквизит.Тип);
		КонецЦикла;
		
		// Стандартные табличные части
		Если (Класс = КлассыМетаданных().ПланыСчетов ИЛИ Класс = КлассыМетаданных().ПланыВидовРасчета) Тогда
			
			Для Каждого СтандартнаяТабличнаяЧасть Из ОбъектМетаданных.СтандартныеТабличныеЧасти Цикл
				Для Каждого СтандартныйРеквизит Из СтандартнаяТабличнаяЧасть.СтандартныеРеквизиты Цикл
					ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, СтандартныйРеквизит.Тип);
				КонецЦикла;
			КонецЦикла;
			
		КонецЕсли;
		
		// Реквизиты
		Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, Реквизит.Тип);
		КонецЦикла;
		
		// Табличные части
		Для Каждого ТабличнаяЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
			// Стандартные реквизиты
			Для Каждого СтандартныйРеквизит Из ТабличнаяЧасть.СтандартныеРеквизиты Цикл
				ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, СтандартныйРеквизит.Тип);
			КонецЦикла;
			// Реквизиты
			Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
				ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, Реквизит.Тип);
			КонецЦикла;
		КонецЦикла;
		
		Если Класс = КлассыМетаданных().Задачи Тогда
			
			// Реквизиты адресации
			Для Каждого РеквизитАдресации Из ОбъектМетаданных.РеквизитыАдресации Цикл
				ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, РеквизитАдресации.Тип);
			КонецЦикла;
			
		КонецЕсли;
		
		Если Класс = КлассыМетаданных().Документы Тогда
			
			// Движения
			Для Каждого Регистр Из ОбъектМетаданных.Движения Цикл
				ЗависимостиОбъекта.Вставить(Регистр.ПолноеИмя(), Истина);
			КонецЦикла;
			
		КонецЕсли;
		
		Если Класс = КлассыМетаданных().ПланыВидовХарактеристик Тогда
			
			// Типы характеристик
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, ОбъектМетаданных.Тип);
			
			// Дополнительные значения характеристик
			Если ОбъектМетаданных.ДополнительныеЗначенияХарактеристик <> Неопределено Тогда
				ЗависимостиОбъекта.Вставить(ОбъектМетаданных.ДополнительныеЗначенияХарактеристик.ПолноеИмя(), Истина);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Класс = КлассыМетаданных().ПланыСчетов Тогда
			
			// Признаки учета
			Для Каждого ПризнакУчета Из ОбъектМетаданных.ПризнакиУчета Цикл
				ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, ПризнакУчета.Тип);
			КонецЦикла;
			
			// Виды субконто
			Если ОбъектМетаданных.ВидыСубконто <> Неопределено Тогда
				ЗависимостиОбъекта.Вставить(ОбъектМетаданных.ВидыСубконто.ПолноеИмя(), Истина);
			КонецЕсли;
			
			// Признаки учета субконто
			Для Каждого ПризнакУчетаСубконто Из ОбъектМетаданных.ПризнакиУчетаСубконто Цикл
				ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, ПризнакУчетаСубконто.Тип);
			КонецЦикла;
			
		КонецЕсли;
		
		Если Класс = КлассыМетаданных().ПланыВидовРасчета Тогда
			
			// Базовые виды расчета
			Для Каждого БазовыйВидРасчета Из ОбъектМетаданных.БазовыеВидыРасчета Цикл
				ЗависимостиОбъекта.Вставить(БазовыйВидРасчета.ПолноеИмя(), Истина);
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли Класс = КлассыМетаданных().Последовательности Тогда
		
		// Измерения
		Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, Измерение.Тип);
		КонецЦикла;
		
		// Входящие документы
		Для Каждого ВходящийДокумент Из ОбъектМетаданных.Документы Цикл
			ЗависимостиОбъекта.Вставить(ВходящийДокумент.ПолноеИмя(), Истина);
		КонецЦикла;
		
		// Движения
		Для Каждого Регистр Из ОбъектМетаданных.Движения Цикл
			ЗависимостиОбъекта.Вставить(Регистр.ПолноеИмя(), Истина);
		КонецЦикла;
		
	ИначеЕсли (Класс = КлассыМетаданных().РегистрыСведений
			ИЛИ Класс = КлассыМетаданных().РегистрыНакопления
			ИЛИ Класс = КлассыМетаданных().РегистрыБухгалтерии
			ИЛИ Класс = КлассыМетаданных().РегистрыРасчета) Тогда
		
		// Стандартные реквизиты
		Для Каждого СтандартныйРеквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, СтандартныйРеквизит.Тип);
		КонецЦикла;
		
		// Измерения
		Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, Измерение.Тип);
		КонецЦикла;
		
		// Ресурсы
		Для Каждого Ресурс Из ОбъектМетаданных.Ресурсы Цикл
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, Ресурс.Тип);
		КонецЦикла;
		
		// Реквизиты
		Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
			ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(ЗависимостиОбъекта, Реквизит.Тип);
		КонецЦикла;
		
		Если Класс = КлассыМетаданных().РегистрыБухгалтерии Тогда
			
			// План счетов
			Если ОбъектМетаданных.ПланСчетов <> Неопределено Тогда
				ЗависимостиОбъекта.Вставить(ОбъектМетаданных.ПланСчетов.ПолноеИмя(), Истина);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Класс = КлассыМетаданных().РегистрыРасчета Тогда
			
			// План видов расчета
			Если ОбъектМетаданных.ПланВидовРасчета <> Неопределено Тогда
				ЗависимостиОбъекта.Вставить(ОбъектМетаданных.ПланВидовРасчета.ПолноеИмя(), Истина);
			КонецЕсли;
			
			// График
			Если ОбъектМетаданных.График <> Неопределено Тогда
				ЗависимостиОбъекта.Вставить(ОбъектМетаданных.График.ПолноеИмя(), Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Класс = КлассыМетаданных().ЖурналыДокументов Тогда
		
		Для Каждого Документ Из ОбъектМетаданных.РегистрируемыеДокументы Цикл
			ЗависимостиОбъекта.Вставить(Документ.ПолноеИмя(), Истина);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоТипамЗависимостейОбъектаМетаданных(Знач Результат, Знач ОписаниеТипов)
	
	Если ОбщегоНазначенияБТС.ЭтоНаборТиповСсылок(ОписаниеТипов) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Тип Из ОписаниеТипов.Типы() Цикл
		
		Если ОбщегоНазначенияБТС.ЭтоСсылочныйТип(Тип) Тогда
			
			Зависимость = ОбщегоНазначенияБТС.ОбъектМетаданныхПоТипуСсылки(Тип);
			
			Если Результат.Получить(Зависимость.ПолноеИмя()) = Неопределено Тогда
				
				Результат.Вставить(Зависимость.ПолноеИмя(), Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоФункциональнымОпциям(Знач Модель)
	
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		
		Для Каждого ЭлементСостава Из ФункциональнаяОпция.Состав Цикл
			
			Если ЭлементСостава.Объект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ОписаниеОбъекта = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, ЭлементСостава.Объект); // см. НовыйОписаниеОбъекта
			 
			Если ОписаниеОбъекта <> Неопределено Тогда
				ОписаниеОбъекта.ФункциональныеОпции.Добавить(ФункциональнаяОпция.Имя);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМодельПоРазделителям(Знач Модель)
	
	// Заполняем по составу общего реквизита
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			
			ИспользоватьОбщийРеквизит = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
				АвтоИспользоватьОбщийРеквизит = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто;
				АвтоИспользованиеОбщегоРеквизита = 
					(ОбщийРеквизит.АвтоИспользование = Метаданные.СвойстваОбъектов.АвтоИспользованиеОбщегоРеквизита.Использовать);
			
			Для Каждого ЭлементСостава Из ОбщийРеквизит.Состав Цикл
				
				Если (АвтоИспользованиеОбщегоРеквизита И ЭлементСостава.Использование = АвтоИспользоватьОбщийРеквизит)
						ИЛИ ЭлементСостава.Использование = ИспользоватьОбщийРеквизит Тогда
					
					ОписаниеОбъекта = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, ЭлементСостава.Метаданные);
					
					Если ЭлементСостава.УсловноеРазделение <> Неопределено Тогда
						ЭлементУсловногоРазделения = ЭлементСостава.УсловноеРазделение.ПолноеИмя();
					Иначе
						ЭлементУсловногоРазделения = "";
					КонецЕсли;
					
					ОписаниеОбъекта.РазделениеДанных.Вставить(ОбщийРеквизит.Имя, ЭлементУсловногоРазделения);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Дополнительно считаем разделенными последовательности, в состав которых входят разделенные документы.
	
	Для Каждого Последовательность Из Метаданные.Последовательности Цикл
		
		Если Последовательность.Документы.Количество() > 0 Тогда
			
			ОписаниеПоследовательности = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, Последовательность);
			
			Для Каждого Документ Из Последовательность.Документы Цикл
				
				ОписаниеДокумента = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, Документ);
				
				Для Каждого КлючИЗначение Из ОписаниеДокумента.РазделениеДанных Цикл
					
					ОписаниеПоследовательности.РазделениеДанных.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
					
				КонецЦикла;
				
				Прервать;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Дополнительно считаем разделенными журналы документов, в состав которых входят разделенные документы.
	
	Для Каждого ЖурналДокументов Из Метаданные.ЖурналыДокументов Цикл
		
		Если ЖурналДокументов.РегистрируемыеДокументы.Количество() > 0 Тогда
			
			ОписаниеЖурнала = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, ЖурналДокументов);
			
			Для Каждого Документ Из ЖурналДокументов.РегистрируемыеДокументы Цикл
				
				ОписаниеДокумента = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, Документ);
				
				Для Каждого КлючИЗначение Из ОписаниеДокумента.РазделениеДанных Цикл
					
					ОписаниеЖурнала.РазделениеДанных.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
					
				КонецЦикла;
				
				Прервать;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Дополнительно считаем разделенными перерасчеты, которые подсинены разделенным регистрам расчета.
	
	Для Каждого РегистрРасчета Из Метаданные.РегистрыРасчета Цикл
		
		Если РегистрРасчета.Перерасчеты.Количество() > 0 Тогда
			
			ОписаниеРегистраРасчета = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, РегистрРасчета);
			
			Для Каждого Перерасчет Из РегистрРасчета.Перерасчеты Цикл
				
				ОписаниеПерерасчета = ОбщегоНазначенияБТС.СвойстваОбъектаМоделиКонфигурации(Модель, Перерасчет);
				
				Для Каждого КлючИЗначение Из ОписаниеРегистраРасчета.РазделениеДанных Цикл
					
					ОписаниеПерерасчета.РазделениеДанных.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ФиксироватьМодель(Знач Модель)
	
	Если ТипЗнч(Модель) = Тип("Массив") Тогда
		
		Результат = Новый Массив();
		Для Каждого Элемент Из Модель Цикл
			Результат.Добавить(ФиксироватьМодель(Элемент));
		КонецЦикла;
		Возврат Новый ФиксированныйМассив(Результат);
		
	ИначеЕсли ТипЗнч(Модель) = Тип("Структура") Тогда
		
		Результат = Новый Структура();
		Для Каждого КлючИЗначение Из Модель Цикл
			Результат.Вставить(КлючИЗначение.Ключ, ФиксироватьМодель(КлючИЗначение.Значение));
		КонецЦикла;
		Возврат Новый ФиксированнаяСтруктура(Результат);
		
	ИначеЕсли  ТипЗнч(Модель) = Тип("Соответствие") Тогда
		
		Результат = Новый Соответствие();
		Для Каждого КлючИЗначение Из Модель Цикл
			Результат.Вставить(КлючИЗначение.Ключ, ФиксироватьМодель(КлючИЗначение.Значение));
		КонецЦикла;
		Возврат Новый ФиксированноеСоответствие(Результат);
		
	Иначе
		
		Возврат Модель;
		
	КонецЕсли;
	
КонецФункции


#КонецОбласти
