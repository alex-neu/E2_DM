////////////////////////////////////////////////////////////////////////////////
// Бизнес процессы и задачи вызов сервера
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получить структуру с описанием формы выполнения задачи.
//
// Параметры
// - ЗадачаСсылка – ЗадачаСсылка.ЗадачаИсполнителя – задача
//
// Возвращаемое значение:
// - Структура – структура с описанием формы выполнения задачи
//
Функция ПолучитьФормуВыполненияЗадачи(Знач ЗадачаСсылка) Экспорт
	
	Если ТипЗнч(ЗадачаСсылка) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный тип параметра ЗадачаСсылка (передан: %1; ожидается: %2)'"),
			ТипЗнч(ЗадачаСсылка),
			"ЗадачаСсылка.ЗадачаИсполнителя");
		
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗадачаСсылка, "БизнесПроцесс, ТочкаМаршрута");
	Если Реквизиты.БизнесПроцесс = Неопределено Или Реквизиты.БизнесПроцесс.Пустая() Тогда
		Возврат Новый Структура();
	КонецЕсли;
	
	ТипБизнесПроцесса = Метаданные.НайтиПоТипу(ТипЗнч(Реквизиты.БизнесПроцесс));
	ПараметрыФормы = БизнесПроцессы[ТипБизнесПроцесса.Имя].ФормаВыполненияЗадачи(
		ЗадачаСсылка,
		Реквизиты.ТочкаМаршрута);
	Возврат ПараметрыФормы;
	
КонецФункции

// Проверяет, находится ли в ячейке отчета ссылка на задачу и в параметре
// ЗначениеРасшифровки возвращает значение расшифровки.
//
Функция ЭтоЗадачаИсполнителю(Знач Расшифровка, Знач ДанныеРасшифровкиОтчета, ЗначениеРасшифровки) Экспорт
	
	ДанныеРасшифровкиОбъект = ПолучитьИзВременногоХранилища(ДанныеРасшифровкиОтчета);
	ЗначениеРасшифровки = ДанныеРасшифровкиОбъект.Элементы[Расшифровка].ПолучитьПоля()[0].Значение;
	Возврат ТипЗнч(ЗначениеРасшифровки) = Тип("ЗадачаСсылка.ЗадачаИсполнителя");
	
КонецФункции

// Выполнить задачу ЗадачаСсылка, при необходимости выполнив обработчик
// ОбработкаВыполненияПоУмолчанию модуля менеджера бизнес-процесса, 
// к которому относится задача ЗадачаСсылка.
//
Процедура ВыполнитьЗадачу(ЗадачаСсылка, ДействиеПоУмолчанию = Ложь) Экспорт

	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ЗадачаСсылка);
		Блокировка.Заблокировать();
		
		ЗадачаОбъект = ЗадачаСсылка.ПолучитьОбъект();
		ЗадачаОбъект.Прочитать();
		Если ДействиеПоУмолчанию И ЗадачаОбъект.БизнесПроцесс <> Неопределено 
			И НЕ ЗадачаОбъект.БизнесПроцесс.Пустая() Тогда
			ТипБизнесПроцесса = ЗадачаОбъект.БизнесПроцесс.Метаданные();
			БизнесПроцессы[ТипБизнесПроцесса.Имя].ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка,
				ЗадачаОбъект.БизнесПроцесс, ЗадачаОбъект.ТочкаМаршрута);
		КонецЕсли;
			
		ЗадачаОбъект.Выполнена = Ложь;
		ЗадачаОбъект.ВыполнитьЗадачу();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

// Перенаправить задачи МассивЗадач новому исполнителю, указанному в структуре
// ИнфоОПеренаправлении. 
//
// Параметры
//  МассивЗадач          – Массив    – массив задач для перенаправления
//  ИнфоОПеренаправлении - Структура - содержит новые значения реквизитов адресации задачи
//  ТолькоПроверка       - Булево    - если Истина, то функция не будет выполнять
//                                     физического перенаправления задач, а только 
//                                     проверит возможность перенаправления.
//  МассивПеренаправленныхЗадач - Массив – массив перенаправленных задач.
//                                         Может отличаться по составу элементов от 
//                                         массива МассивЗадач, если какие-то задачи
//                                         не удалось перенаправить.
//
// Возвращаемое значение:
//   Булево   – Истина, если перенаправление выполнено успешно.
//
Функция ПеренаправитьЗадачи(Знач МассивЗадач, Знач ИнфоОПеренаправлении, Знач ТолькоПроверка = Ложь,
	МассивПеренаправленныхЗадач = Неопределено) Экспорт
	
	Результат = Истина;
	Для Каждого Задача Из МассивЗадач Цикл
		
		ЗадачаВыполнена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Задача.Ссылка, "Выполнена");
		Если ЗадачаВыполнена Тогда
			Результат = Ложь;
			Если ТолькоПроверка Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;	
		
		Если ТолькоПроверка Тогда
			Продолжить;
		КонецЕсли;	
		
		Если НЕ ЗначениеЗаполнено(МассивПеренаправленныхЗадач) Тогда
			МассивПеренаправленныхЗадач = Новый Массив();
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Задача.Ссылка);
			Блокировка.Заблокировать();
							
			// Не устанавливаем объектную блокировку на задачу Задача для того, чтобы 
			// позволить выполнять перенаправление по команде из формы этой задачи.
			ЗадачаОбъект = Задача.Ссылка.ПолучитьОбъект();
			
			УстановитьПривилегированныйРежим(Истина);
			НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			НоваяЗадача.Заполнить(ЗадачаОбъект);
			ЗаполнитьЗначенияСвойств(НоваяЗадача, ИнфоОПеренаправлении, 
				"Исполнитель, РольИсполнителя");
			НоваяЗадача.Записать();
			УстановитьПривилегированныйРежим(Ложь);
		
			МассивПеренаправленныхЗадач.Добавить(НоваяЗадача.Ссылка);
			
			ЗадачаОбъект.РезультатВыполнения = ИнфоОПеренаправлении.Комментарий; 
			ЗадачаОбъект.Выполнена = Ложь;
			ЗадачаОбъект.ВыполнитьЗадачу();
		
			ПриПеренаправленииЗадачи(ЗадачаОбъект, НоваяЗадача);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(
				БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				Задача.Метаданные(),
				Задача.Ссылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Отменяет выполнение задачи.
//
// Параметры:
//   Задача - ЗадачаСсылка.ЗадачаИсполнителя - задача, выполнение которой будет отменять в
//            текущей функции.
//
// Возвращаемое значение:
//   Структура - содержит результаты отмены выполнения.
//     Отказ - Булево - принимает Истина, если не удалось отменить выполнение задачи.
//     ПричинаОтказа - Строка - текстовое описание причины отказа отмены выполнения задачи.
//
Функция ОтменитьВыполнениеЗадачи(Задача) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("Отказ", Ложь);
	РезультатФункции.Вставить("ПричинаОтказа", "");
	
	РеквизитыЗадачи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Задача, "БизнесПроцесс, ТочкаМаршрута");
	
	НачатьТранзакцию();
	
	ЗаблокироватьДанныеДляРедактирования(РеквизитыЗадачи.БизнесПроцесс);
	
	ЗадачуМожноОтменить = ЗадачуМожноОтменить(Задача); 
	
	Если ЗадачуМожноОтменить.Отказ Тогда
		
		ПричинаОтказа = НСтр("ru = 'Эту задачу нельзя отменить. %1'");
		
		ПричинаОтказа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПричинаОтказа, ЗадачуМожноОтменить.ПричинаОтказа);
		
		РезультатФункции.ПричинаОтказа = ПричинаОтказа;
		РезультатФункции.Отказ = Истина;
		ОтменитьТранзакцию();
		Возврат РезультатФункции;
		
	КонецЕсли;
	
	Попытка
	
		ЗадачаОбъект = Задача.ПолучитьОбъект();
		ЗадачаОбъект.Заблокировать();
		
		Запись = РегистрыСведений.РезультатыВыполненияПроцессовИЗадач.СоздатьМенеджерЗаписи();
		Запись.Объект = Задача;
		Запись.Удалить();
		
		ПроцессОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
		
		Исполнители = ПроцессОбъект.Исполнители;
		НайденнаяСтрока = Исполнители.Найти(Задача, "ЗадачаИсполнителя");
		
		НайденнаяСтрока.Пройден = Ложь;
		
		Если РеквизитыЗадачи.ТочкаМаршрута =
			БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать Тогда
			
			РезультатыСогласования = ПроцессОбъект.РезультатыСогласования;
			НайденнаяСтрока = РезультатыСогласования.Найти(Задача, "ЗадачаИсполнителя");
			
			НайденнаяСтрока.РезультатСогласования =
				Перечисления.РезультатыСогласования.ПустаяСсылка();
			
		КонецЕсли;
		
		ПроцессОбъект.Записать();
		
		ЗадачаОбъект.Выполнена = Ложь;
		ЗадачаОбъект.ДатаИсполнения = '00010101';
		ЗадачаОбъект.Записать();
		
		// Удаление ЭП виз согласования
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВизыСогласования.Ссылка
			|ИЗ
			|	Справочник.ВизыСогласования КАК ВизыСогласования
			|ГДЕ
			|	ВизыСогласования.Источник = &Задача";
		Запрос.УстановитьПараметр("Задача", Задача);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ОбъектВизы = Выборка.Ссылка.ПолучитьОбъект();
			ОбъектВизы.Подписана = Ложь;
			ОбъектВизы.Записать();
			
			РаботаСЭП.УдалитьПодписиОбъекта(Выборка.Ссылка);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		РезультатФункции.ПричинаОтказа = ОписаниеОшибки();
		РезультатФункции.Отказ = Истина;
		Возврат РезультатФункции;
	КонецПопытки;
	
	Возврат РезультатФункции;
	
КонецФункции

// Выполняет проверку возможности отменить выполнение задачи
//
// Параметры:
//   Задача - ЗадачаССылка.ЗадачаИсполнителя - задача, для которой производится проверка.
//
// Возвращаемое значение:
//   - Структура
//       - Отказ - Булево - принимает значение Истина, если задачу отменить нельзя.
//       - ПричинаОтказа - Строка - содержит причину отказа.
//
Функция ЗадачуМожноОтменить(Задача) Экспорт
	
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("Отказ", Ложь);
	РезультатФункции.Вставить("ПричинаОтказа", "");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Задача) Тогда
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Пустая ссылка на задачу.'");
		Возврат РезультатФункции;
	КонецЕсли;
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Задача);
	Если Не ПраваПоОбъекту.Изменение Тогда
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Недостаточно прав.'");
		Возврат РезультатФункции;
	КонецЕсли;
	
	РеквизитыЗадачи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Задача, "ТочкаМаршрута, БизнесПроцесс, Выполнена, ИсключенаИзПроцесса, ПометкаУдаления");
		
	Если НЕ ЗначениеЗаполнено(РеквизитыЗадачи.ТочкаМаршрута) Тогда
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'У задачи не указана точка маршрута.'");
		Возврат РезультатФункции;
	КонецЕсли;	
	
	
	Если НЕ ЗначениеЗаполнено(РеквизитыЗадачи.БизнесПроцесс) Тогда
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'У задачи не указан процесс.'");
		Возврат РезультатФункции;	
	КонецЕсли;
	
	Если НЕ РеквизитыЗадачи.Выполнена Тогда
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Задача не выполнена.'");
		Возврат РезультатФункции;
	КонецЕсли;
	
	Если РеквизитыЗадачи.ИсключенаИзПроцесса Тогда
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Задача исключена из процесса.'");
		Возврат РезультатФункции;
	КонецЕсли;
	
	Если РеквизитыЗадачи.ПометкаУдаления Тогда
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Задача помечена на удаление.'");
		Возврат РезультатФункции;
	КонецЕсли;
	
	Если РеквизитыЗадачи.ТочкаМаршрута = БизнесПроцессы.Исполнение.ТочкиМаршрута.Исполнить Тогда
		
		ВариантИсполнения = "ВариантИсполнения";
		
		ПорядокВыполненияЗадачи = "ПорядокИсполнения";
		
	ИначеЕсли РеквизитыЗадачи.ТочкаМаршрута =
		БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать Тогда
		
		ВариантИсполнения = "ВариантСогласования";
		
		ПорядокВыполненияЗадачи = "ПорядокСогласования";
		
	Иначе
		
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Для задачи не предусмотрена отмена выполнения.'");
		Возврат РезультатФункции;
		
	КонецЕсли;
	
	РеквизитыПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		РеквизитыЗадачи.БизнесПроцесс,
		"Завершен, Исполнители, " + ВариантИсполнения);
	
	Если РеквизитыПроцесса.Завершен Тогда
		
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Задача относится к завершенному процессу.'");
		Возврат РезультатФункции;
		
	КонецЕсли;
	
	ВариантМаршрутизацииЗадачПроцесса = РеквизитыПроцесса[ВариантИсполнения];
	
	Исполнители = РеквизитыПроцесса.Исполнители.Выгрузить();
	
	Исполнители.Сортировать("НомерСтроки Возр");
	
	СтрокаТекущейЗадачи = Исполнители.Найти(Задача,"ЗадачаИсполнителя");
	Если СтрокаТекущейЗадачи = Неопределено Тогда
		
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Задача не найдена в списке исполнителей процесса.'");
		Возврат РезультатФункции;
		
	КонецЕсли;
	
	Если ВариантМаршрутизацииЗадачПроцесса =
		Перечисления.ВариантыМаршрутизацииЗадач.Параллельно Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Пройден", Ложь);
		
		НайденныеСтроки = Исполнители.НайтиСтроки(ПараметрыОтбора);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			Возврат РезультатФункции;
		Иначе
			РезультатФункции.Отказ = Истина;
			РезультатФункции.ПричинаОтказа = НСтр("ru = 'Процесс перешел к следующей точке маршрута.'");
			Возврат РезультатФункции;
		КонецЕсли;
		
	ИначеЕсли ВариантМаршрутизацииЗадачПроцесса =
		Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
		
		ЕстьНеИсполненныеЗадачи = Ложь;
		
		// Перебираем все строки таблицы Исполнители у Процесса начиная с предыдущей
		// в обратном порядке.
		ИндексСтроки = СтрокаТекущейЗадачи.НомерСтроки - 2; // Индекс предыдущей строки
		
		Пока ИндексСтроки >= 0 Цикл
			
			ТекущаяСтрока = Исполнители[ИндексСтроки];
			
			Если ТекущаяСтрока.Пройден = Ложь Тогда
				ЕстьНеИсполненныеЗадачи = Истина;
				Прервать;
			КонецЕсли;
			
			Если ТекущаяСтрока[ПорядокВыполненияЗадачи] <>
				Перечисления.ПорядокВыполненияЗадач.ВместеСПредыдущим Тогда
				
				Прервать;
				
			КонецЕсли;
			
			ИндексСтроки = ИндексСтроки - 1;
			
		КонецЦикла;
		
		Если ЕстьНеИсполненныеЗадачи Тогда
			Возврат РезультатФункции;
		КонецЕсли;
		
		// Перебираем все строки таблицы Исполнители у Процесса начиная со следующей
		// в обратном порядке.
		ИндексСтроки = СтрокаТекущейЗадачи.НомерСтроки; // Индекс следующей строки
		
		КоличествоИсполнителей = Исполнители.Количество();
		
		Пока ИндексСтроки <= КоличествоИсполнителей -1 Цикл
			
			ТекущаяСтрока = Исполнители[ИндексСтроки];
			
			Если ТекущаяСтрока[ПорядокВыполненияЗадачи] <>
				Перечисления.ПорядокВыполненияЗадач.ВместеСПредыдущим Тогда
				
				Прервать;
				
			КонецЕсли;
			
			Если ТекущаяСтрока.Пройден = Ложь Тогда
				ЕстьНеИсполненныеЗадачи = Истина;
				Прервать;
			КонецЕсли;
			
			ИндексСтроки = ИндексСтроки + 1;
			
		КонецЦикла;
		
		Если ЕстьНеИсполненныеЗадачи Тогда
			Возврат РезультатФункции;
		КонецЕсли;
		
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = НСтр("ru = 'Процесс перешел на следующий этап.'");
		Возврат РезультатФункции;
		
	Иначе
		
		РезультатФункции.Отказ = Истина;
		РезультатФункции.ПричинаОтказа = 
			НСтр("ru = 'Отмена выполнения предусмотрена только при параллельном или смешанном выполнении.'");
		Возврат РезультатФункции;
		
	КонецЕсли;
	
КонецФункции

// Отмечает указанные задачи как принятые к исполнению
//
Процедура ПринятьЗадачиКИсполнению(Задачи) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Для каждого Задача Из Задачи Цикл
			Если ТипЗнч(Задача) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
				ЗадачаОбъект = Задача.ПолучитьОбъект();
				ЗадачаОбъект.Заблокировать();
				
				Если ЗадачаОбъект.Выполнена
					ИЛИ ЗадачаОбъект.СостояниеБизнесПроцесса <> Перечисления.СостоянияБизнесПроцессов.Активен
					ИЛИ ЗадачаОбъект.ПринятаКИсполнению
					ИЛИ ЗадачаОбъект.ПометкаУдаления Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				ЗадачаОбъект.ПринятаКИсполнению = Истина;
				ЗадачаОбъект.ДатаПринятияКИсполнению = ТекущаяДатаСеанса();
				Если ЗадачаОбъект.Исполнитель.Пустая() Тогда
					ЗадачаОбъект.Исполнитель = ПользователиКлиентСервер.ТекущийПользователь();
				КонецЕсли;
				
				ЗадачаОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Отмечает указанные задачи как не принятые к исполнению
//
Процедура ОтменитьПринятиеЗадачКИсполнению(Задачи) Экспорт
	
	НачатьТранзакцию();
	Попытка
		НовыйМассивЗадач = Новый Массив();
		Для каждого Задача Из Задачи Цикл
			Если ТипЗнч(Задача) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
				ЗадачаОбъект = Задача.ПолучитьОбъект();
				ЗадачаОбъект.Заблокировать();
				
				Если ЗадачаОбъект.Выполнена
					ИЛИ ЗадачаОбъект.СостояниеБизнесПроцесса <> Перечисления.СостоянияБизнесПроцессов.Активен
					ИЛИ НЕ ЗадачаОбъект.ПринятаКИсполнению
					ИЛИ ЗадачаОбъект.ПометкаУдаления Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				ЗадачаОбъект.ПринятаКИсполнению = Ложь;
				ЗадачаОбъект.ДатаПринятияКИсполнению = "00010101000000";
				Если Не ЗадачаОбъект.РольИсполнителя.Пустая() Тогда
					ЗадачаОбъект.Исполнитель = Справочники.Пользователи.ПустаяСсылка();
				КонецЕсли;
				ЗадачаОбъект.Записать();
				
				НовыйМассивЗадач.Добавить(Задача)
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
		Задачи = НовыйМассивЗадач;
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает число не завершенных подчиненных процессов по указанному бизнес-процессу
//
Функция ПолучитьЧислоНевыполненныхПодчиненныхПроцессовБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеБизнесПроцессов.БизнесПроцесс
		|ИЗ
		|	РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК Задачи
		|		ПО ДанныеБизнесПроцессов.ВедущаяЗадача = Задачи.Ссылка
		|ГДЕ
		|	Задачи.БизнесПроцесс = &БизнесПроцесс
		|	И Задачи.Выполнена = ЛОЖЬ
		|	И Задачи.СостояниеБизнесПроцесса <> ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Прерван)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДанныеБизнесПроцессов.БизнесПроцесс
		|ИЗ
		|	РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК Задачи
		|		ПО ДанныеБизнесПроцессов.ГлавнаяЗадача = Задачи.Ссылка
		|ГДЕ
		|	Задачи.БизнесПроцесс = &БизнесПроцесс
		|	И Задачи.Выполнена = ЛОЖЬ
		|	И Задачи.СостояниеБизнесПроцесса <> ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Прерван)";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = 0;
	
	Пока Выборка.Следующий() Цикл
		Результат = Результат + 1 + ПолучитьЧислоНевыполненныхПодчиненныхПроцессовБизнесПроцесса(
			Выборка.БизнесПроцесс);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает дату завершения указанного бизнес-процесса,
// полученную как максимальная дата исполнения задач бизнес-процесса.
//
// Параметры
//  БизнесПроцессСсылка  - бизнес-процесс
//
// Возвращаемое значение:
//   Дата
//
Функция ДатаЗавершенияБизнесПроцесса(БизнесПроцессСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(ЗадачаИсполнителя.ДатаИсполнения) КАК МаксДатаИсполнения
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
		|	И ЗадачаИсполнителя.Выполнена = ИСТИНА";
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат ТекущаяДатаСеанса();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.МаксДатаИсполнения;
	
КонецФункции

// Возвращает число невыполненных задач по указанным бизнес-процессам
//
Функция ПолучитьЧислоНевыполненныхЗадачБизнесПроцессов(БизнесПроцессы) Экспорт
	
	ЧислоЗадач = 0;
	
	Для каждого БизнесПроцесс Из БизнесПроцессы Цикл
		
		Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ЧислоЗадач = ЧислоЗадач + ПолучитьЧислоНевыполненныхЗадачБизнесПроцесса(БизнесПроцесс);
		
	КонецЦикла;
	
	Возврат ЧислоЗадач;
	
КонецФункции

// Возвращает число невыполненных задач по указанному бизнес-процессу
//
Функция ПолучитьЧислоНевыполненныхЗадачБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|	Задачи.БизнесПроцесс = &БизнесПроцесс
		|	И Задачи.Выполнена = Ложь
		|	И Задачи.СостояниеБизнесПроцесса <> ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Прерван)";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Количество;
	
КонецФункции

// Проверяет, является ли указанная задача ведущей.
//
// Параметры
//  ЗадачаСсылка  - задача.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоВедущаяЗадача(ЗадачаСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = БизнесПроцессыИЗадачиСервер.ВыбратьБизнесПроцессыВедущейЗадачи(ЗадачаСсылка);
	Возврат Не Результат.Пустой();
	
КонецФункции

// Возвращает массив подчиненных указанной задаче бизнес-процессов
//
// Параметры
//  ЗадачаСсылка  - задача.
//
// Возвращаемое значение:
//   массив ссылок на бизнес-процессы
//
Функция ПолучитьБизнесПроцессыГлавнойЗадачи(ЗадачаСсылка) Экспорт
	
	Результат = Новый Массив;
	Для Каждого ТипБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		Попытка
			ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	%1.Ссылка КАК Ссылка
				|ИЗ
				|	%2 КАК %1
				|ГДЕ
				|	%1.ГлавнаяЗадача = &ГлавнаяЗадача", ТипБизнесПроцесса.Имя, ТипБизнесПроцесса.ПолноеИмя());
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("ГлавнаяЗадача", ЗадачаСсылка);
			
			РезультатЗапроса = Запрос.Выполнить();
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				Результат.Добавить(Выборка.Ссылка);
			КонецЦикла;
			
		Исключение
			// У бизнес-процесса может и не быть главной задачи
		КонецПопытки
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает количество вопросов выполнения задачи.
// При вычислении учитываются права доступа.
//
// Параметры:
//  Задача - ЗадачаСсылка.ЗадачаИсполнителя - Задача, для которой производится вычисление
//           количества вопросов.
//
// Возвращаемое значение:
//   Число - количество вопросов выполнения.
//
Функция КоличествоВопросовВыполненияЗадачи(Задача) Экспорт

	Если НЕ ЗначениеЗаполнено(Задача) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	РешениеВопросовВыполненияЗадач.Ссылка
		|ИЗ
		|	БизнесПроцесс.РешениеВопросовВыполненияЗадач КАК РешениеВопросовВыполненияЗадач
		|ГДЕ
		|	РешениеВопросовВыполненияЗадач.ПредметРассмотрения = &Задача";
		
	Запрос.УстановитьПараметр("Задача", Задача);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Возврат Выборка.Количество();

КонецФункции

// Возвращает имя актуальной формы задач в соответствии с персональными настройками.
//
Функция ИмяФормыЗадачиМне() Экспорт
	
	ИмяФормы = "Задача.ЗадачаИсполнителя.Форма.ЗадачиМне";
	
	ВидФормы = ХранилищеОбщихНастроек.Загрузить("Задачи", "ВидФормыЗадачиМне");
	Если ВидФормы = 1 Тогда
		ИмяФормы = "Задача.ЗадачаИсполнителя.Форма.ЗадачиМнеБезГруппировкиПоПредметам";
	КонецЕсли;
	
	Возврат ИмяФормы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Помечает на удаление указанные бизнес-процессы
//
Функция ПометитьНаУдалениеБизнесПроцессы(ВыделенныеСтроки) Экспорт
	
	Количество = 0;
	Для каждого СтрокаТаблицы Из ВыделенныеСтроки Цикл
		БизнесПроцессСсылка = СтрокаТаблицы.БизнесПроцесс;
		Если БизнесПроцессСсылка = Неопределено Или БизнесПроцессСсылка.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		БизнесПроцессОбъект = БизнесПроцессСсылка.ПолучитьОбъект();
		БизнесПроцессОбъект.УстановитьПометкуУдаления(Не БизнесПроцессОбъект.ПометкаУдаления);
		Количество = Количество + 1;
	КонецЦикла;
	Возврат ?(Количество = 1, ВыделенныеСтроки[0].БизнесПроцесс, Неопределено);
	
КонецФункции

Процедура ПриПеренаправленииЗадачи(ЗадачаОбъект, НоваяЗадачаОбъект) 
	
	Если ЗадачаОбъект.БизнесПроцесс = Неопределено Или ЗадачаОбъект.БизнесПроцесс.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ТипБизнесПроцесса = ЗадачаОбъект.БизнесПроцесс.Метаданные();
	Попытка
		БизнесПроцессы[ТипБизнесПроцесса.Имя].ПриПеренаправленииЗадачи(ЗадачаОбъект.Ссылка, НоваяЗадачаОбъект.Ссылка);
	Исключение
		// метод не определен
	КонецПопытки;
	
КонецПроцедуры

// Проверяет наличие прав для того, чтобы отметить бизнес-процесс
// как остановленный или активный
//
Функция ЕстьПраваНаОстановкуБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Результат = БизнесПроцессыИЗадачиПереопределяемый.ЕстьПраваНаОстановкуБизнесПроцесса(БизнесПроцесс);
	Если Результат <> Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПравоНаИзменениеБП = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(БизнесПроцесс).Изменение;
	
	Возврат ПравоНаИзменениеБП;
	
КонецФункции

// Записать бизнес-процесс БизнесПроцессСсылка в общий список,
// задав при этом значения полей из структуры ЗначенияПолей.
// 
Процедура ЗаписатьВСписокБизнесПроцессов(БизнесПроцессСсылка, ЗначенияПолей) Экспорт
	
	ЗначенияПолей.Вставить(
		"ТрудозатратыПлан", 
		РаботаСБизнесПроцессамиВызовСервера.ПолучитьСуммарныеТрудозатратыПроцессаЧас(БизнесПроцессСсылка));
	ЗначенияПолей.Вставить("БизнесПроцесс", БизнесПроцессСсылка);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеБизнесПроцессов.БизнесПроцесс,
		|	ДанныеБизнесПроцессов.Номер,
		|	ДанныеБизнесПроцессов.Важность,
		|	ДанныеБизнесПроцессов.ВедущаяЗадача,
		|	ДанныеБизнесПроцессов.Дата,
		|	ДанныеБизнесПроцессов.Завершен,
		|	ДанныеБизнесПроцессов.Стартован,
		|	ДанныеБизнесПроцессов.Автор,
		|	ДанныеБизнесПроцессов.ДатаЗавершения,
		|	ДанныеБизнесПроцессов.ОбъектДоступа,
		|	ДанныеБизнесПроцессов.Наименование,
		|	ДанныеБизнесПроцессов.СрокИсполнения,
		|	ДанныеБизнесПроцессов.ПометкаУдаления,
		|	ДанныеБизнесПроцессов.НомерИтерации,
		|	ДанныеБизнесПроцессов.ОсновнойПредмет,
		|	ДанныеБизнесПроцессов.ДатаНачала,
		|	ДанныеБизнесПроцессов.УзелОбмена,
		|	ДанныеБизнесПроцессов.ГлавнаяЗадача,
		|	ДанныеБизнесПроцессов.Проект,
		|	ДанныеБизнесПроцессов.ПроектнаяЗадача,
		|	ДанныеБизнесПроцессов.Состояние,
		|	ДанныеБизнесПроцессов.ТрудозатратыПлан
		|ИЗ
		|	РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|ГДЕ
		|	ДанныеБизнесПроцессов.БизнесПроцесс = &БизнесПроцесс";
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЕстьРазличия = Ложь;
		Для Каждого КлючЗначение Из ЗначенияПолей Цикл
			Если КлючЗначение.Значение <> Выборка[КлючЗначение.Ключ] Тогда
				ЕстьРазличия = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ ЕстьРазличия Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	МенеджерЗаписи = РегистрыСведений.ДанныеБизнесПроцессов.СоздатьМенеджерЗаписи();
	
	Если Выборка.Количество() > 0 Тогда
		МенеджерЗаписи.БизнесПроцесс = Выборка.БизнесПроцесс;
		МенеджерЗаписи.Завершен = Выборка.Завершен;
		МенеджерЗаписи.Прочитать();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ЗначенияПолей);
	БизнесПроцессыИЗадачиПереопределяемый.ПриЗаписиСпискаБизнесПроцессов(МенеджерЗаписи);
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Записать();

КонецПроцедуры

// Помечает на удаление задачи указанного бизнес-процесса.
//
// Параметры
//  БизнесПроцессСсылка  - бизнес-процесс
//  ПометкаУдаления  - Булево - значение свойства ПометкаУдаления.
//
Процедура УстановитьПометкуУдаленияЗадач(БизнесПроцессСсылка, ПометкаУдаления) Экспорт
	
	ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БизнесПроцессСсылка, "ПометкаУдаления");
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		УстановитьПривилегированныйРежим(Истина);
		БизнесПроцессыИЗадачиСервер.УстановитьПометкуУдаленияЗадач(БизнесПроцессСсылка, ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

// Пометить на удаление вложенные и подчиненные бизнес-процессы задачи ЗадачаСсылка.
//
// Параметры
//  ЗадачаСсылка                 - ЗадачаСсылка.ЗадачаИсполнителя
//  НовоеЗначениеПометкиУдаления - Булево
//
Процедура ПриПометкеУдаленияЗадачи(ЗадачаСсылка, НовоеЗначениеПометкиУдаления) Экспорт
	
	ОбъектЗадачи = ЗадачаСсылка.Метаданные();
	Если НовоеЗначениеПометкиУдаления И Не ПравоДоступа("ИнтерактивнаяПометкаУдаления", ОбъектЗадачи) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.'");
	КонецЕсли;
	Если Не НовоеЗначениеПометкиУдаления И Не ПравоДоступа("ИнтерактивноеСнятиеПометкиУдаления", ОбъектЗадачи) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.'");
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		// Помечаем вложенные бизнес-процессы
		УстановитьПривилегированныйРежим(Истина);
		ВложенныеБизнесПроцессы = БизнесПроцессыИЗадачиСервер.БизнесПроцессыВедущейЗадачи(ЗадачаСсылка);
		Для каждого ВложенныйБизнесПроцесс Из ВложенныеБизнесПроцессы Цикл
			БизнесПроцессОбъект = ВложенныйБизнесПроцесс.ПолучитьОбъект();
			БизнесПроцессОбъект.УстановитьПометкуУдаления(НовоеЗначениеПометкиУдаления);
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
		
		// Помечаем подчиненные бизнес-процессы
		ПодчиненныеБизнесПроцессы = ПолучитьБизнесПроцессыГлавнойЗадачи(ЗадачаСсылка);
		Для каждого ПодчиненныйБизнесПроцесс Из ПодчиненныеБизнесПроцессы Цикл
			БизнесПроцессОбъект = ПодчиненныйБизнесПроцесс.ПолучитьОбъект();
			БизнесПроцессОбъект.Заблокировать();
			БизнесПроцессОбъект.УстановитьПометкуУдаления(НовоеЗначениеПометкиУдаления);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Записать событие открытия карточки и также записать обращение к объекту
Процедура ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Задача) Экспорт
	
	ИсторияСобытийЗадач.ЗаписатьСобытиеОткрытаКарточка(Задача);
	РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Задача);
	
КонецПроцедуры

// Получает имя формы бизнес-процесса по шаблону бизнес-процесса
Функция ПолучитьИмяФормыПроцессаПоШаблону(Шаблон) Экспорт
	
	ИмяПроцесса = Справочники[Шаблон.Метаданные().Имя].ИмяПроцесса(Шаблон);
	Возврат Метаданные.БизнесПроцессы[ИмяПроцесса].ОсновнаяФормаОбъекта.ПолноеИмя();
	
КонецФункции

// Отмечает указанные бизнес-процессы как активные
//
Процедура СделатьАктивнымБизнесПроцессы(БизнесПроцессы) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		Для каждого БизнесПроцесс Из БизнесПроцессы Цикл
			
			Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			
			СделатьАктивнымБизнесПроцесс(БизнесПроцесс);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
 		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как активный
//
Процедура СделатьАктивнымБизнесПроцесс(БизнесПроцесс) Экспорт
	
	Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьПраваНаОстановкуБизнесПроцесса(БизнесПроцесс) Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вашего уровня доступа недостаточно для того, чтобы сделать активным процесс ""%1"".'"),
			Строка(БизнесПроцесс));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Объект = БизнесПроцесс.ПолучитьОбъект();
	
	Если Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Активен Тогда
		ВызватьИсключение НСтр("ru = 'Процесс уже активен.'");
	КонецЕсли;
	
	Если Объект.Завершен Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно сделать активными завершенные процессы.'");
	КонецЕсли;
		
	Если Не Объект.Стартован Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно сделать активными не стартовавшие процессы.'");
	КонецЕсли;
	
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцесс);
	Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
	Объект.Записать();
	РазблокироватьДанныеДляРедактирования(БизнесПроцесс);
	
КонецПроцедуры

// Отмечает указанные бизнес-процессы как остановленные
//
Процедура ОстановитьБизнесПроцессы(БизнесПроцессы) Экспорт
	
	НачатьТранзакцию();
	Попытка 
		Для каждого БизнесПроцесс Из БизнесПроцессы Цикл
			
			Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			
			ОстановитьБизнесПроцесс(БизнесПроцесс);
			
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как остановленный
//
Процедура ОстановитьБизнесПроцесс(БизнесПроцесс) Экспорт
	
	Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьПраваНаОстановкуБизнесПроцесса(БизнесПроцесс) Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вашего уровня доступа недостаточно для остановки процесса ""%1"".'"),
			Строка(БизнесПроцесс));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Объект = БизнесПроцесс.ПолучитьОбъект();
	
	Если Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Остановлен Тогда
		ВызватьИсключение НСтр("ru = 'Процесс уже остановлен.'");
	КонецЕсли;
	
	Если Объект.Завершен = Истина Тогда
		ВызватьИсключение НСтр("ru = 'Нельзя останавливать завершенные процессы.'");
	КонецЕсли;
		
	Если Объект.Стартован <> Истина Тогда
		ВызватьИсключение НСтр("ru = 'Нельзя останавливать не стартовавшие процессы.'");
	КонецЕсли;
	
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцесс);
	Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Остановлен;
	Объект.Записать();
	РазблокироватьДанныеДляРедактирования(БизнесПроцесс);
	
КонецПроцедуры

// Возвращает Истина если задача соответствует указанной точке маршрута
Функция ПроверитьТипЗадачи(Задача, ТочкаМаршрута) Экспорт
	
	Возврат Задача.ТочкаМаршрута = ТочкаМаршрута;
	
КонецФункции

Процедура ПрерватьБизнесПроцесс(БизнесПроцесс, ПричинаПрерывания) Экспорт
	
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцесс);
	Попытка
		БизнесПроцессОбъект = БизнесПроцесс.ПолучитьОбъект();
		БизнесПроцессОбъект.Состояние = ПредопределенноеЗначение(
			"Перечисление.СостоянияБизнесПроцессов.Прерван");
		БизнесПроцессОбъект.ПричинаПрерывания = ПричинаПрерывания;
		БизнесПроцессОбъект.Записать();
		РазблокироватьДанныеДляРедактирования(БизнесПроцесс);
	Исключение
		РазблокироватьДанныеДляРедактирования(БизнесПроцесс);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция ТекущиеУчастникиПроцесса(Процесс) Экспорт
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Процесс)) Тогда
		МенеджерПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Процесс);
	Иначе
		МенеджерПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Процесс.Ссылка);
	КонецЕсли;
	
	Возврат МенеджерПроцесса.ТекущиеУчастникиПроцесса(Процесс);
	
КонецФункции

// Прерывает подзадачи (процессы) указанной задачи)
Процедура ПрерватьПодзадачи(Задача) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст
	 = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	   |	ДочерниеБизнесПроцессы.ДочернийПроцесс КАК ДочернийПроцесс,
	   |	ДанныеБизнесПроцессов.ВедущаяЗадача КАК ВедущаяЗадача,
	   |	ДанныеБизнесПроцессов.Стартован КАК Стартован,
	   |	ДанныеБизнесПроцессов.Завершен КАК Завершен
	   |ИЗ
	   |	РегистрСведений.ДочерниеБизнесПроцессы КАК ДочерниеБизнесПроцессы
	   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
	   |		ПО ДочерниеБизнесПроцессы.ДочернийПроцесс = ДанныеБизнесПроцессов.БизнесПроцесс
	   |ГДЕ
	   |	ДанныеБизнесПроцессов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)
	   |	И ДанныеБизнесПроцессов.Завершен = ЛОЖЬ
	   |	И ДочерниеБизнесПроцессы.СвязующаяЗадача = &Задача";
	 
	Запрос.УстановитьПараметр("Задача", Задача);
	ТаблицаПроцессов = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр Из ТаблицаПроцессов Цикл
		
		ПраваПоПроцессу = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Стр.ДочернийПроцесс);
		
		Если Не ПраваПоПроцессу.Изменение Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не Стр.Стартован Или ЗначениеЗаполнено(Стр.ВедущаяЗадача) Тогда
			Продолжить;
		КонецЕсли;	
		
		ПрерватьБизнесПроцесс(Стр.ДочернийПроцесс, НСтр("ru = 'Перенаправление задачи:'") + Строка(Задача));
			
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ОбновитьПараметрыУсловногоОформленияПросроченныхПодзадач(УсловноеОформление) Экспорт
	
	ПредставлениеЭлемента1 = НСтр("ru = 'Срок истек (подзадачи)'");
	ПредставлениеЭлемента2 = НСтр("ru = 'Срок истек (подзадачи, описание)'");
	
	ЭлементОформления = Неопределено;
	
	Для Каждого Элемент из УсловноеОформление.Элементы Цикл
		Если Элемент.Представление = ПредставлениеЭлемента1
			Или Элемент.Представление = ПредставлениеЭлемента2 Тогда
			ЭлементОформления = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭлементОформления = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ПослеСрокПодзадачи = Новый ПолеКомпоновкиДанных("Подзадачи.Срок");
	ТипДата = Тип("Дата");
	
	Для Каждого ЭлементОтбора Из ЭлементОформления.Отбор.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = ПослеСрокПодзадачи
			И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше
			И ТипЗнч(ЭлементОтбора.ПравоеЗначение) = ТипДата Тогда
			
			ЭлементОтбора.ПравоеЗначение = ТекущаяДата();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти