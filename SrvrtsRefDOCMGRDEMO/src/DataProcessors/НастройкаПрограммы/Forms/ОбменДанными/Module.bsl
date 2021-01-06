
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Элементы.ГруппаПрефиксИЗапретРедактированияСтатейДДС.Видимость = Ложь;
		Элементы.ИспользоватьСВД.Видимость = Ложь;
		Элементы.ЯвляетсяСерверомСВД.Видимость = Ложь;
		Элементы.ВыполняетсяПлавноеОбновлениеС20.Видимость = Ложь;
		
	Иначе
		
		Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Доступность = 
			НаборКонстант.ИспользоватьСинхронизациюДанных;

		Элементы.ЗапретитьРедактированиеСтатейДвиженияДенежныхСредств.Доступность = 
			НаборКонстант.ИспользоватьСинхронизациюДанных;
		
		Элементы.ЗапретитьРедактированиеТоваровИУслуг.Доступность = 
			НаборКонстант.ИспользоватьСинхронизациюДанных;
			
	КонецЕсли;
		
	Элементы.ИспользоватьPushУведомления.Доступность = НаборКонстант.ИспользоватьМобильныеКлиенты;

	Элементы.Настроить.Доступность = 
		НаборКонстант.ИспользоватьМобильныеКлиенты И НаборКонстант.ИспользоватьPushУведомления;

	Элементы.НастроитьЭДО.Доступность = НаборКонстант.ИспользоватьОбменЭД;

	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	АдресПубликацииНаВебСервере = НаборКонстант.АдресПубликацииНаВебСервере;
	
	Элементы.АдресПубликацииНаВебСервере.Доступность = НаборКонстант.ИспользоватьМобильныеКлиенты;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОбменДаннымиПриИзменении(Элемент)

	Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Доступность = 
		НаборКонстант.ИспользоватьСинхронизациюДанных;

	Элементы.ЗапретитьРедактированиеСтатейДвиженияДенежныхСредств.Доступность = 
		НаборКонстант.ИспользоватьСинхронизациюДанных;
	Элементы.ЗапретитьРедактированиеТоваровИУслуг.Доступность = 
		НаборКонстант.ИспользоватьСинхронизациюДанных;
	
	Если НаборКонстант.ИспользоватьСинхронизациюДанных Тогда
		НаборКонстант.ЗапретитьРедактированиеСтатейДвиженияДенежныхСредств = Истина;
		НаборКонстант.ЗапретитьРедактированиеТоваровИУслуг = Истина;
	Иначе
		НаборКонстант.ЗапретитьРедактированиеСтатейДвиженияДенежныхСредств = Ложь;
		НаборКонстант.ЗапретитьРедактированиеТоваровИУслуг = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьМобильныеКлиентыПриИзменении(Элемент)

	Если Не НаборКонстант.ИспользоватьМобильныеКлиенты Тогда
		НаборКонстант.ИспользоватьPushУведомления = Ложь;
	КонецЕсли;

	Элементы.ИспользоватьPushУведомления.Доступность = Ложь;
		//НаборКонстант.ИспользоватьМобильныеКлиенты;

	Элементы.Настроить.Доступность = Ложь;
		//НаборКонстант.ИспользоватьМобильныеКлиенты И НаборКонстант.ИспользоватьPushУведомления;

	Элементы.АдресПубликацииНаВебСервере.Доступность = НаборКонстант.ИспользоватьМобильныеКлиенты;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьPushУведомленияПриИзменении(Элемент)

	Элементы.Настроить.Доступность = НаборКонстант.ИспользоватьPushУведомления;

КонецПроцедуры

&НаКлиенте
Процедура Настроить(Команда)

	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.НастройкаPushУведомлений",,
		ЭтаФорма, , , , , РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьЭДО(Команда,ПараметрыВыполненияКоманды)
	
	Записать();
	ОткрытьФорму("Обработка.ПанельАдминистрированияЭДО.Форма.ОбменЭлектроннымиДокументами",,
		ЭтаФорма, , , , , РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	Если НаборКонстант.ИспользоватьСинхронизациюДанных Тогда
		НаборКонстант.ИспользоватьФоновоеВыполнениеЗадач = Истина;
		НаборКонстант.ИспользоватьФоновуюМаршрутизациюКомплексныхПроцессов = Истина;
	КонецЕсли;
	
	НаборКонстант.АдресПубликацииНаВебСервере = АдресПубликацииНаВебСервере;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменЭДПриИзменении(Элемент)

	Элементы.НастроитьЭДО.Доступность = НаборКонстант.ИспользоватьОбменЭД;

КонецПроцедуры

#КонецОбласти
