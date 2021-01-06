
// Определяет по письму связанную ветку переписки.
//
// Параметры:
//  Письмо - ссылка на документ ВходящиеПисьмо, ИсходящееПисьмо
//         - ссылка на справочник ВходящийДокумент, ИсходящийДокумент.
//  СоздаватьВетку - булево - необходимость создания ветки, если она не существует.
//
// Возвращаемое значение:
//  Ссылка на справочник ВеткиПереписки. Если связь не существует, тогда возвращает Неопределено.
//
Функция ПолучитьВетку(Письмо, СоздаватьВетку = Истина) Экспорт
	
	// Создаем ветку, если она ещё не создана.
	Если СоздаватьВетку Тогда
		ВстроеннаяПочтаСервер.ОбновитьВеткуПереписки(Письмо);
	КонецЕсли;
	
	ВеткаПереписки = Неопределено;
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Письмо) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПисьмаВеток.ВеткаПереписки
			|ИЗ
			|	РегистрСведений.ПисьмаВеток КАК ПисьмаВеток
			|ГДЕ
			|	ПисьмаВеток.Письмо = &Письмо";
		Запрос.УстановитьПараметр("Письмо", Письмо);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ВеткаПереписки = Выборка.ВеткаПереписки;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоВходящийДокумент(Письмо)
		ИЛИ ДелопроизводствоКлиентСервер.ЭтоИсходящийДокумент(Письмо) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВеткиПереписки.Ссылка
			|ИЗ
			|	Справочник.ВеткиПереписки КАК ВеткиПереписки
			|ГДЕ
			|	ВеткиПереписки.КорневоеПисьмо = &Письмо";
		Запрос.УстановитьПараметр("Письмо", Письмо);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Не Выборка.Следующий() Тогда
			ВеткаПереписки = Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВеткаПереписки = Неопределено И СоздаватьВетку Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Получение ветки переписки'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			Письмо,
			НСтр("ru = 'Отсутствует связь между письмом и веткой переписки.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		
	КонецЕсли;
	
	Возврат ВеткаПереписки;
	
КонецФункции

// Определяет для письма ветку переписки по письму-основанию либо создает новую ветку.
//
// Параметры:
//  Письма - ДокументСсылка.ИсходящееПисьмо
//
Процедура ОпределитьВеткуДляЧерновика(Письмо) Экспорт
	
	// Письмо уже может быть привязано к ветке.
	Если ЗначениеЗаполнено(ПолучитьВетку(Письмо, Ложь)) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Письмо.ПисьмоОснование) Тогда
		
		НоваяВетка = Справочники.ВеткиПереписки.СоздатьЭлемент();
		НоваяВетка.КорневоеПисьмо = Письмо.Ссылка;
		НоваяВетка.КоличествоПисемВПереписке = 1;
		НоваяВетка.Записать();
		
		ВеткаПереписки = НоваяВетка.Ссылка;
		
	Иначе
		
		ВеткаПереписки = ПолучитьВетку(Письмо.ПисьмоОснование);
		
		Если ВеткаПереписки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ПисьмаВеток.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Письмо = Письмо;
	МенеджерЗаписи.ВеткаПереписки = ВеткаПереписки.Ссылка;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры
