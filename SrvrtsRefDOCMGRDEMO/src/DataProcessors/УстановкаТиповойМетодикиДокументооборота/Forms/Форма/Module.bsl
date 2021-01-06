
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	ТекущийПользовательСлужебный = 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийПользователь, "Служебный");
	
	Если ТекущийПользовательСлужебный Тогда
		ОписаниеОшибки = НСтр("ru = 'Обработка не может быть запущена в сеансе служебного пользователя.
			|Запустите программу под обычным пользователем с административными правами и повторите попытку.'");
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьУстановку(Команда)
	
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.СтартУстановки;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановку(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьУстановкуПослеВопросаПередЗапуском", ЭтотОбъект);
		
	СтрокаЗаполненныхДанных = ЗаполненныеДанные();
	Если ЗначениеЗаполнено(СтрокаЗаполненныхДанных) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗаполненныеДанные", СтрокаЗаполненныхДанных);
		
		ОткрытьФорму("Обработка.УстановкаТиповойМетодикиДокументооборота.Форма.ФормаПредупрежденияПередУстановкой",
			ПараметрыФормы,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	
КонецПроцедуры

// Продолжение процедуры НачатьУстановку.
&НаКлиенте
Процедура НачатьУстановкуПослеВопросаПередЗапуском(Результат, Параметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.Установка;
	
	ПодключитьОбработчикОжидания("УстановитьТиповуюМетодику", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗадач(Команда)
	
	Закрыть();
	
	ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.ЗадачиМне");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьТиповуюМетодику()
	
	ЗаполнитьБазу();
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.УстановкаЗавершена;
	
КонецПроцедуры

// Заполняет базу настройками и данными по типовой методике.
//
&НаСервере
Процедура ЗаполнитьБазу()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	
	РезультатЗаполнения = Обработка.ЗаполнитьБазу();
	
	Элементы.УстановкаЗавершенаОписание.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.УстановкаЗавершенаОписание.Заголовок,
		РезультатЗаполнения.ЗаполненныеДанные,
		РезультатЗаполнения.КоличествоСозданныхЗадач);
	
КонецПроцедуры

// Возвращает строку с заполненными данными в базе.
//
// Возвращаемое значение:
//   Строка
//
&НаСервере
Функция ЗаполненныеДанные()
	
	Результат = "";
	
	СимволBullet = Символ(8226);
	
	Обработка = РеквизитФормыВЗначение("Объект");
	ТаблицаЗаполненныхДанных = Обработка.ЗаполненныеДанныеВ_ИБ();
	
	Если ТаблицаЗаполненныхДанных <> Неопределено
		И ТаблицаЗаполненныхДанных.Количество() > 0 Тогда
		
		РазделительСтрок = "";
		
		Для Каждого СтрСтрТаблицыРезультатовПроверки Из ТаблицаЗаполненныхДанных Цикл
			Результат = Результат + РазделительСтрок + СимволBullet + " "
				+ СтрСтрТаблицыРезультатовПроверки.НаименованиеОбъекта+ ": "
				+ СтрСтрТаблицыРезультатовПроверки.КоличествоЗаписей;
				
			РазделительСтрок =  Символы.ПС;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти





