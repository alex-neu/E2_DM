
// Отправить сообщения СВД
Функция ОтправитьСообщения(Транспорт) Экспорт 
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	Если Транспорт.ФорматСообщения = ПредопределенноеЗначение("Справочник.ФорматыСообщенийСВД.ОператорЭДО1СТакском") Тогда
		МенеджерОбъекта = Справочники.УдалитьСоглашенияОбИспользованииЭД;
	Иначе
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	КонецЕсли;
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ОтправитьСообщения(
			НастройкаПриемаОтправки, Транспорт);
	КонецЕсли;	
		
	Возврат Ложь;
	
КонецФункции	

// Получить сообщения СВД
Функция ПолучитьСообщения(Транспорт) Экспорт 
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	Если Транспорт.ФорматСообщения = ПредопределенноеЗначение("Справочник.ФорматыСообщенийСВД.ОператорЭДО1СТакском") Тогда
		МенеджерОбъекта = Справочники.УдалитьСоглашенияОбИспользованииЭД;
	Иначе
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	КонецЕсли;
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ПолучитьСообщения(
			НастройкаПриемаОтправки, Транспорт);
	КонецЕсли;	
		
	Возврат Ложь;
	
КонецФункции	

// Получить наименование контрагента в СВД
Функция ПолучитьНаименованиеКонтрагентаВСВД(Контрагент, Транспорт) Экспорт
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ПолучитьНаименованиеКонтрагентаВСВД(Контрагент, Транспорт);
	КонецЕсли;	
		
	Возврат "";
	
КонецФункции	

// Получить наименование организации в СВД
Функция ПолучитьНаименованиеОрганизацииВСВД(ОрганизацияДокумента, Транспорт) Экспорт
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ПолучитьНаименованиеОрганизацииВСВД(ОрганизацияДокумента, Транспорт);
	КонецЕсли;	
		
	Возврат "";
	
КонецФункции	
