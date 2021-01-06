
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПравилоАК")
		ИЛИ Параметры.ПравилоАК = Неопределено
		ИЛИ Параметры.ПравилоАК.Пустая() Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	Правило = Параметры.ПравилоАК;	
	Элементы.ВнутренниеДокументы.Видимость = Ложь;
	Элементы.ВходящиеДокументы.Видимость = Ложь;
	Элементы.ИсходящиеДокументы.Видимость = Ложь;
	Элементы.Файлы.Видимость = Ложь;
	
	Для Каждого ТипОбъекта Из Правило.ТипыОбъектов Цикл
		Элементы[ОбщегоНазначения.ИмяЗначенияПеречисления(ТипОбъекта.ТипДанных)].Видимость = Истина;	
	КонецЦикла;
	
		
	РезультатыПроверки.Очистить();
	Для Каждого Условие Из Правило.Условия Цикл
		НоваяСтрока = РезультатыПроверки.Добавить();
		НоваяСтрока.Условие = Условие.Выражение;
		НоваяСтрока.РезультатПроверки = "";		
	КонецЦикла;
	
 	СостояниеПроверкиПравила = 0;
	СостояниеПроверкиПравилаНадпись = "Проверка на данном объекте не произведена";
	
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(СписокВнутренниеДокументы);
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(СписокВходящиеДокументы);
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(СписокИсходящиеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыКатегоризацииПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущийЭлемент = Элементы["Список" + ТекущаяСтраница.Имя]; 
	Если НЕ ТекущийЭлемент.ТекущиеДанные = Неопределено
		И ТекущийОбъектВСписке <> ТекущийЭлемент.ТекущиеДанные.Ссылка Тогда
		ТекущийОбъектВСписке = ТекущийЭлемент.ТекущиеДанные.Ссылка;
		УстановитьНевидимостьСтатусаПоиска();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВнутренниеДокументыПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено
		И ТекущийОбъектВСписке <> Элемент.ТекущиеДанные.Ссылка Тогда
		ТекущийОбъектВСписке = Элемент.ТекущиеДанные.Ссылка;
		УстановитьНевидимостьСтатусаПоиска();
		Если ПроверятьПриВыделении Тогда
			ПроверитьПравилоНаОбъекте(Неопределено);	
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено
		И ТекущийОбъектВСписке <> Элемент.ТекущиеДанные.Ссылка Тогда
		ТекущийОбъектВСписке = Элемент.ТекущиеДанные.Ссылка;
		УстановитьНевидимостьСтатусаПоиска();
		Если ПроверятьПриВыделении Тогда
			ПроверитьПравилоНаОбъекте(Неопределено);	
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокИсходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено
		И ТекущийОбъектВСписке <> Элемент.ТекущиеДанные.Ссылка Тогда
		ТекущийОбъектВСписке = Элемент.ТекущиеДанные.Ссылка;
		УстановитьНевидимостьСтатусаПоиска();
		Если ПроверятьПриВыделении Тогда
			ПроверитьПравилоНаОбъекте(Неопределено);	
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокФайлыПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено
		И ТекущийОбъектВСписке <> Элемент.ТекущиеДанные.Ссылка Тогда
		ТекущийОбъектВСписке = Элемент.ТекущиеДанные.Ссылка;
		УстановитьНевидимостьСтатусаПоиска();
		Если ПроверятьПриВыделении Тогда
			ПроверитьПравилоНаОбъекте(Неопределено);	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНевидимостьСтатусаПоиска()
	
	СостояниеПроверкиПравила = 0;
	СостояниеПроверкиПравилаНадпись = "Проверка на данном объекте не произведена";
	Для Каждого Строка Из РезультатыПроверки Цикл
		Строка.РезультатПроверки = "";
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПравилоНаОбъекте(Команда)
	
	ДанныеПроверки = ПроверитьПравило(ТекущийОбъектВСписке);
		РезультатыПроверки.Очистить();
	Для Каждого РезультатПроверки Из ДанныеПроверки Цикл
		НоваяСтрока = РезультатыПроверки.Добавить();
		НоваяСтрока.Условие = РезультатПроверки.Условие;
		НоваяСтрока.РезультатПроверки = РезультатПроверки.РезультатПроверкиУсловия;
	КонецЦикла;
	
	ИтоговыйРезультат = Ложь;
	Для Каждого РезультатПроверки Из ДанныеПроверки Цикл
		ИтоговыйРезультат = ИтоговыйРезультат
			ИЛИ (ТипЗнч(РезультатПроверки.РезультатПроверкиУсловия) = Тип("Булево")
			И РезультатПроверки.РезультатПроверкиУсловия = Истина);
		Если ТипЗнч(РезультатПроверки.РезультатПроверкиУсловия) <> Тип("Булево") Тогда
			ИтоговыйРезультат = Ложь;
			Прервать;
		КонецЕсли;	
	КонецЦикла;
		
	Если ИтоговыйРезультат Тогда
		СостояниеПроверкиПравила = 2;
		СостояниеПроверкиПравилаНадпись = "Правило подходит для данного объекта";
	Иначе
		СостояниеПроверкиПравила = 1;
		СостояниеПроверкиПравилаНадпись = "Правило неприменимо для данного объекта";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПравило(ТекущийОбъект)
	
	Возврат РаботаСКатегориямиДанных.ВыполнитьПроверкуПрименимостиПравилаАвтоКатегоризацииНаОбъекте(Правило, ТекущийОбъектВСписке);
	
КонецФункции

&НаКлиенте
Процедура РезультатыПроверкиПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		ВыражениеТекущегоУсловия = Элемент.ТекущиеДанные.Условие;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры
