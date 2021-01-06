// Возвращает ссылку на объект, к которому прикреплен шаблон контрольных точек
Функция ПолучитьВидОбъектаКТ(ОбъектКТ) Экспорт
	
	Если ТипЗнч(ОбъектКТ) = Тип("СправочникСсылка.Проекты") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектКТ, "ВидПроекта");
	КонецЕсли;	
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает ссылку на ответственного объекта контрольной точки
Функция ОтветственныйОбъектаКТ(Знач ОбъектКТ) Экспорт
	
	Если ТипЗнч(ОбъектКТ) = Тип("СправочникСсылка.Проекты") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектКТ, "Руководитель");
	КонецЕсли;	
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает ссылку на рабочий график объекта КТ
Функция ПолучитьГрафикОбъектаКТ(ОбъектКТ) Экспорт
	
	Если ТипЗнч(ОбъектКТ) = Тип("СправочникСсылка.Проекты") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектКТ, "ГрафикРаботы"); 
	КонецЕсли;	
	
	Возврат Неопределено;
	
КонецФункции	

// Возвращает Истина, если у указанного объекта есть хотя бы одна группа контрольных точек
Функция ЕстьГруппы(ОбъектКТ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ГруппыКонтрольныхТочек.Ссылка
		|ИЗ
		|	Справочник.ГруппыКонтрольныхТочек КАК ГруппыКонтрольныхТочек
		|ГДЕ
		|	ГруппыКонтрольныхТочек.ПометкаУдаления = Ложь
		|	И ГруппыКонтрольныхТочек.ОбъектКТ = &ОбъектКТ";
	
	Запрос.УстановитьПараметр("ОбъектКТ", ОбъектКТ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

// Записывает новые контрольные точки по списку
// 
// Параметры
//	Оценка	- ПеречислениеСсылка.ВероятностиКТ
//	Дата	- Дата
//	Автор	- СправочникСсылка.Пользователи
//	Комментарий	- Срока
//	СписокКТ	- Массив контрольных точек
// 
Процедура УстановитьОценку(Знач Оценка, Знач Дата, Знач Автор, Знач Комментарий, Знач СписокКТ) Экспорт 
	
	НачатьТранзакцию();
	
	Попытка
		
		Для каждого КонтрольнаяТочка Из СписокКТ Цикл
			РеквизитыКТ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КонтрольнаяТочка, "Проверено, Ответственный");
			Если РеквизитыКТ.Ответственный = Пользователи.ТекущийПользователь() 
				И РеквизитыКТ.Проверено Тогда 
					Продолжить; 
			КонецЕсли;
			
			РегистрыСведений.ОценкиКонтрольныхТочек.Добавить(Дата, КонтрольнаяТочка, Автор, Оценка, Комментарий);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Установка оценок контрольных точек'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;	
		
КонецПроцедуры

// Запрос новых контрольных точек по объекту, по списку
// 
// Параметры
//	ОбъектКТ - Определяемый тип ОбъектыКТ - Объект контрольных точек
//	СписокКТ - Массив контрольных точек к запросу оценки
//
Процедура ЗапроситьОценки(Знач ОбъектКТ = Неопределено, Знач СписокКТ = Неопределено, КоличествоЗапрошенныхОценок) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Если СписокКТ = Неопределено
		И ОбъектКТ = Неопределено Тогда
			Возврат;
	КонецЕсли;
	
	ДатаНачала = НачалоНедели(ТекущаяДатаСеанса());
	ДатаОкончания = КонецНедели(ДатаНачала);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Оценки.Оценка,
		|	Оценки.КонтрольнаяТочка
		|ПОМЕСТИТЬ ВсеОценки
		|ИЗ
		|	РегистрСведений.ОценкиКонтрольныхТочек КАК Оценки
		|ГДЕ
		|	Оценки.Период >= &ДатаНачала
		|	И Оценки.Период <= &ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтрольныеТочки.Ссылка
		|ИЗ
		|	Справочник.КонтрольныеТочки КАК КонтрольныеТочки
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВсеОценки КАК ВсеОценки
		|		ПО (ВсеОценки.КонтрольнаяТочка = КонтрольныеТочки.Ссылка)
		|ГДЕ
		|	ВсеОценки.Оценка ЕСТЬ NULL 
		|	И КонтрольныеТочки.ПометкаУдаления = ЛОЖЬ
		|	И КонтрольныеТочки.Проверено = ЛОЖЬ";
		
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Если СписокКТ <> Неопределено И СписокКТ.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + 
		" 
		|	И КонтрольныеТочки.Ссылка В (&СписокКТ) ";
		Запрос.УстановитьПараметр("СписокКТ", СписокКТ);
	КонецЕсли;
	
	Если ОбъектКТ <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + 
		" 
		|	И КонтрольныеТочки.ОбъектКТ = &ОбъектКТ ";
		Запрос.УстановитьПараметр("ОбъектКТ", ОбъектКТ);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		РегистрыСведений.ОценкиКонтрольныхТочек.Добавить(
			ТекущаяДатаСеанса(),
			Выборка.Ссылка,
			Пользователи.ТекущийПользователь(),
			Перечисления.ВероятностиКТ.НеОпределено,
			"");
			
		КоличествоЗапрошенныхОценок = КоличествоЗапрошенныхОценок + 1; 	
			
	КонецЦикла;

КонецПроцедуры

// Помечает на удаление контрольные точки
// 
//	СписокКТ - Массив контрольных точек к запросу оценки
// 
Процедура УдалитьКонтрольныеТочки(Знач СписокКТ) Экспорт
	
	НачатьТранзакцию();

	Попытка
		
		Для каждого КонтрольнаяТочка Из СписокКТ Цикл
			Если ЗначениеЗаполнено(КонтрольнаяТочка) Тогда 
				КТ = КонтрольнаяТочка.ПолучитьОбъект();
				КТ.УстановитьПометкуУдаления(Истина);
				КТ.Записать();	
			КонецЕсли;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление контрольных точек'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОтменитьТранзакцию();	
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Заполняет регистр КешИнформацииОбОбъектах
//
//	НаборЗаписей - РегистрСведенийНаборЗаписей.ОценкиКонтрольныхТочек 
//
Процедура ПриЗаписиОценки(НаборЗаписей) Экспорт 

	УстановитьПривилегированныйРежим(Истина);
	
	Если НаборЗаписей.Количество() <> 0 Тогда
		
		Для НомерЗаписи = 0 По НаборЗаписей.Количество() - 1 Цикл
			
			КонтрольнаяТочка = НаборЗаписей.Получить(НомерЗаписи).КонтрольнаяТочка;
			ОбъектКТ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтрольнаяТочка, "ОбъектКТ");
			
			Если ТипЗнч(ОбъектКТ) <> Тип("СправочникСсылка.Проекты") Тогда
				Продолжить;
			КонецЕсли;
			
			ВероятностьОбъекта = ВероятностьОбъектаПоКонтрольнойТочке(КонтрольнаяТочка);
			РегистрыСведений.КешИнформацииОбОбъектах.УстановитьПризнак(
				ОбъектКТ, "ВероятностьКТ", ВероятностьОбъекта); 
						
		КонецЦикла;
		
	Иначе 
		
		КонтрольнаяТочка = НаборЗаписей.Отбор.КонтрольнаяТочка.Значение;
		
		Если КонтрольнаяТочка <> Неопределено Тогда
			
			ОбъектКТ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтрольнаяТочка, "ОбъектКТ");
			Если ТипЗнч(ОбъектКТ) <> Тип("СправочникСсылка.Проекты") Тогда
				Возврат;
			КонецЕсли;
			
			ВероятностьОбъекта = ВероятностьОбъектаПоКонтрольнойТочке(КонтрольнаяТочка);
			РегистрыСведений.КешИнформацииОбОбъектах.УстановитьПризнак(
				ОбъектКТ, "ВероятностьКТ", ВероятностьОбъекта);
			
		КонецЕсли;
		
	КонецЕсли;	

КонецПроцедуры

// Возвращает вероятность оценки объекта контрольной точки
//
// Параметры
//	КонтрольнаяТочка - СправочникСсылка.КонтрольныеТочки
//
Функция ВероятностьОбъектаПоКонтрольнойТочке(Знач КТ) Экспорт 

	УстановитьПривилегированныйРежим(Истина);
	
	ВероятностьКТ = Перечисления.ВероятностиКТ.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтрольныеТочки.Ссылка,
		|	КонтрольныеТочкиОбъект.ОбъектКТ
		|ПОМЕСТИТЬ КТПоОбъекту
		|ИЗ
		|	Справочник.КонтрольныеТочки КАК КонтрольныеТочкиОбъект
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтрольныеТочки КАК КонтрольныеТочки
		|		ПО КонтрольныеТочкиОбъект.ОбъектКТ = КонтрольныеТочки.ОбъектКТ
		|			И (КонтрольныеТочки.ПометкаУдаления = ЛОЖЬ)
		|ГДЕ
		|	КонтрольныеТочкиОбъект.Ссылка = &КТ
		|	И КонтрольныеТочкиОбъект.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЕСТЬNULL(Оценки.Оценка, ЗНАЧЕНИЕ(Перечисление.ВероятностиКТ.ПустаяСсылка)) КАК Оценка,
		|	МИНИМУМ(ВЫБОР
		|			КОГДА Оценки.Оценка = ЗНАЧЕНИЕ(Перечисление.ВероятностиКТ.ВСрок)
		|				ТОГДА 3
		|			КОГДА Оценки.Оценка = ЗНАЧЕНИЕ(Перечисление.ВероятностиКТ.ЕстьНесущественныеРиски)
		|				ТОГДА 2
		|			КОГДА Оценки.Оценка = ЗНАЧЕНИЕ(Перечисление.ВероятностиКТ.ПодУгрозой)
		|				ТОГДА 1
		|			КОГДА Оценки.Оценка = ЗНАЧЕНИЕ(Перечисление.ВероятностиКТ.НеОпределено)
		|				ТОГДА 4
		|			ИНАЧЕ 5
		|		КОНЕЦ) КАК Приоритет,
		|	КТПоОбъекту.ОбъектКТ КАК ОбъектКТ
		|ИЗ
		|	КТПоОбъекту КАК КТПоОбъекту
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОценкиКонтрольныхТочек.СрезПоследних КАК Оценки
		|		ПО КТПоОбъекту.Ссылка = Оценки.КонтрольнаяТочка
		|
		|СГРУППИРОВАТЬ ПО
		|	Оценки.Оценка,
		|	КТПоОбъекту.ОбъектКТ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	
	Запрос.УстановитьПараметр("КТ", КТ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ВероятностьКТ = Выборка.Оценка;
	КонецЕсли;
	
	Возврат ВероятностьКТ;

КонецФункции 

// Выводит светофор в карточке объекта
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма проекта
//
Процедура ВывестиКартинкуКонтрольныхТочек(Форма) Экспорт 
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольныеТочки") Тогда 
		Возврат;
	КонецЕсли;	
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	КешИнформации = РегистрыСведений.КешИнформацииОбОбъектах.СоздатьМенеджерЗаписи();
	КешИнформации.Объект = Объект.Ссылка;
	КешИнформации.Прочитать();
	
	Если Не ЗначениеЗаполнено(КешИнформации.ВероятностьКТ) Тогда 
		Форма.СтатусСветофорКТ = 4; 
		Элементы.КартинкаСветофор.Подсказка = НСтр("ru = 'Нет оценки по контрольным точкам'");
		
	ИначеЕсли КешИнформации.ВероятностьКТ = Перечисления.ВероятностиКТ.ВСрок Тогда
		Форма.СтатусСветофорКТ = 3;
		Элементы.КартинкаСветофор.Подсказка = НСтр("ru = 'Нет рисков по контрольным точкам'");
		
	ИначеЕсли КешИнформации.ВероятностьКТ = Перечисления.ВероятностиКТ.ЕстьНесущественныеРиски Тогда
		Форма.СтатусСветофорКТ = 2;
		Элементы.КартинкаСветофор.Подсказка = НСтр("ru = 'Есть несущественные риски по контрольным точкам'");
		
	ИначеЕсли КешИнформации.ВероятностьКТ = Перечисления.ВероятностиКТ.ПодУгрозой Тогда
		Форма.СтатусСветофорКТ = 1;
		Элементы.КартинкаСветофор.Подсказка = НСтр("ru = 'Есть риск получения результата в срок'");
		
	ИначеЕсли КешИнформации.ВероятностьКТ = Перечисления.ВероятностиКТ.НеОпределено Тогда
		Форма.СтатусСветофорКТ = 6;
		Элементы.КартинкаСветофор.Подсказка = НСтр("ru = 'Оценка по контрольным точкам не определена ответственными'");	
		
	КонецЕсли;	

КонецПроцедуры

// Возвращает структуру оценки с контрольной точки
//
// Параметры
//	КонтрольнаяТочка - СправочникСсылка.КонтрольныеТочки
//
Функция ОценкаКонтрольнойТочки(Знач КонтрольнаяТочка) Экспорт 
	
	Результат = Новый Структура;
	Результат.Вставить("Период", Дата(1,1,1));
	Результат.Вставить("Автор", Справочники.Пользователи.ПустаяСсылка());
	Результат.Вставить("Оценка", Перечисления.ВероятностиКТ.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Оценки.Период,
		|	Оценки.Автор,
		|	Оценки.Оценка
		|ИЗ
		|	РегистрСведений.ОценкиКонтрольныхТочек.СрезПоследних(, КонтрольнаяТочка = &КонтрольнаяТочка) КАК Оценки";
	
	Запрос.УстановитьПараметр("КонтрольнаяТочка", КонтрольнаяТочка);
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Функция выполняет подсчет групп КТ и КТ по объекту
//
// Параметры
//	ОбъектКТ - Определяемый тип ОбъектыКТ - Объект контрольных точек
//
Функция ОтсутствуютГруппыИТочки(Знач ОбъектКТ) Экспорт 

	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ГруппыКонтрольныхТочек.Ссылка
		|ИЗ
		|	Справочник.ГруппыКонтрольныхТочек КАК ГруппыКонтрольныхТочек
		|ГДЕ
		|	ГруппыКонтрольныхТочек.ОбъектКТ = &ОбъектКТ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	КонтрольныеТочки.Ссылка
		|ИЗ
		|	Справочник.КонтрольныеТочки КАК КонтрольныеТочки
		|ГДЕ
		|	КонтрольныеТочки.ОбъектКТ = &ОбъектКТ";
	
	Запрос.УстановитьПараметр("ОбъектКТ", ОбъектКТ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = Ложь;		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Функция выполняет подсчет КТ по объекту
//
// Параметры
//	ОбъектКТ - Определяемый тип ОбъектыКТ - Объект контрольных точек
//
Функция ПолучитьЧислоКТБезГруппы(Знач ОбъектКТ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ЧислоКТ
		|ИЗ
		|	Справочник.КонтрольныеТочки КАК КонтрольныеТочки
		|ГДЕ
		|	КонтрольныеТочки.ПометкаУдаления = Ложь
		|	И КонтрольныеТочки.ГруппаКТ = &ГруппаКТ
		|	И КонтрольныеТочки.ОбъектКТ = &ОбъектКТ";
	
	Запрос.УстановитьПараметр("ГруппаКТ", Справочники.ГруппыКонтрольныхТочек.ПустаяСсылка());
	Запрос.УстановитьПараметр("ОбъектКТ", ОбъектКТ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = ВыборкаДетальныеЗаписи.ЧислоКТ;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции
