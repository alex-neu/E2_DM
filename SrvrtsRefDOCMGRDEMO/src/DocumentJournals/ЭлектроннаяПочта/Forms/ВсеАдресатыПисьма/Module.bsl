#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Письмо = Параметры.Письмо;
	ТипАдреса = Параметры.ТипАдреса;
	
	Если ТипАдреса = "Кому" Тогда
		Заголовок = НСтр("ru = 'Получатели письма'");
	Иначе
		Заголовок = НСтр("ru = 'Получатели копий'");
	КонецЕсли;	
	
	ПолучатьФотографии = Истина;
	
	ОтображатьФотографииПерсональнаяНастройка =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиПрограммы",
			"ОтображатьФотографииПерсональнаяНастройка",
			Истина);
	
	ОтображатьФотографииОбщаяНастройка = ПолучитьФункциональнуюОпцию("ОтображатьФотографииОбщаяНастройка");
	ПриложениеЯвляетсяВебКлиентом = ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом();
	
	Если Не ОтображатьФотографииОбщаяНастройка
		Или Не ОтображатьФотографииПерсональнаяНастройка
		Или ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая
		Или ПриложениеЯвляетсяВебКлиентом Тогда
		ПолучатьФотографии = Ложь;
		Элементы.ГруппаСтраницыФотографии.Видимость = Ложь;
	КонецЕсли;
	
	ЭтаФорма.Элементы.ГруппаСтраницыФотографии.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаКартинкаПоУмолчанию;
	
	Получатели.Очистить();
	
	ЗаполнитьПолучателейКомуКопия();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФотографияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Получатели.ТекущиеДанные <> Неопределено Тогда
		
		Контакт = Элементы.Получатели.ТекущиеДанные.Контакт;
		Если ЗначениеЗаполнено(Контакт) Тогда
			ПоказатьЗначение(, Контакт);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийПолучательНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Получатели.ТекущиеДанные <> Неопределено Тогда
		
		Контакт = Элементы.Получатели.ТекущиеДанные.Контакт;
		Если ЗначениеЗаполнено(Контакт) Тогда
			ПоказатьЗначение(, Контакт);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеКонтактаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НаписатьПисьмо();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаДанных = Получатели.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока);
	Если ЗначениеЗаполнено(СтрокаДанных.Контакт) Тогда
		ПоказатьЗначение(, СтрокаДанных.Контакт);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Получатели.ТекущиеДанные <> Неопределено Тогда
		
		Элементы.ПолучателиПредставление.КнопкаОткрытия = ЗначениеЗаполнено(Элементы.Получатели.ТекущиеДанные.Контакт);
		
	КонецЕсли;
	
	Если Элементы.Получатели.ТекущиеДанные <> Неопределено Тогда
		
		Контакт = Элементы.Получатели.ТекущиеДанные.Контакт;
		
		ТекущийПолучательПредставление = Элементы.Получатели.ТекущиеДанные.Представление;
		Элементы.ТекущийПолучатель.Гиперссылка = ЗначениеЗаполнено(Контакт);
		
		Если ТекущийПолучатель <> Контакт Тогда
			
			ТекущийПолучатель = Контакт;
			ТекущийПолучательПредставление = Строка(ТекущийПолучатель);
			
			Если Не ЗначениеЗаполнено(ТекущийПолучатель) Тогда
				ТекущийПолучательПредставление = Элементы.Получатели.ТекущиеДанные.Представление;
			КонецЕсли;	
			
			ПодключитьОбработчикОжидания("ОбновитьФотоПользователя", 0.2, Истина);
			
		КонецЕсли;
		
	Иначе
		
		Фотография = "";
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПолучателейКомуКопия()
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(Письмо) Тогда
		ТаблицаЗначений = ВстроеннаяПочтаСервер.ПолучитьТаблицуПолучателейКомуКопияУВходящегоПисьма(Письмо);
	Иначе	
		ТаблицаЗначений = ВстроеннаяПочтаСервер.ПолучитьТаблицуПолучателейКомуКопияСкрытаяУИсходящегоПисьма(Письмо);
	КонецЕсли;	
	
	Получатели.Очистить();
	
	Для Каждого Строка Из ТаблицаЗначений Цикл
		
		Если Найти(Строка.ТипАдреса, ТипАдреса) <> 0 Тогда
		
			НоваяСтрока = Получатели.Добавить();
			
			НоваяСтрока.Контакт = Строка.Контакт;
			НоваяСтрока.Представление = Строка.Представление;
			НоваяСтрока.Внешний = Строка.Внешний;
			НоваяСтрока.ТипАдреса = Строка.ТипАдреса;
			НоваяСтрока.Адрес = Строка.Адрес;
			
		КонецЕсли;
		
	КонецЦикла;	
	
	Если ТипАдреса = "Кому" Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получатели письма (%1)'"), Получатели.Количество());
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получатели копий (%1)'"), Получатели.Количество());
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФотоПользователя()
	
	Если Не ПолучатьФотографии Тогда
		Возврат;
	КонецЕсли;	
	
	ПоказатьФотоПользователя(ТекущийПолучатель, УникальныйИдентификатор, Фотография);	
		
КонецПроцедуры

&НаСервере
Процедура ПоказатьФотоПользователя(Контакт, УникальныйИдентификатор, Фотография)
	
	Если Не ПолучатьФотографии Тогда
		Возврат;
	КонецЕсли;	
	
	// фото пользователя
	Если ЭтоАдресВременногоХранилища(Фотография) Тогда
		УдалитьИзВременногоХранилища(Фотография);
	КонецЕсли;	
	
	Фотография = "";
	Если ЗначениеЗаполнено(Контакт) 
		И ТипЗнч(Контакт) <> Тип("СправочникСсылка.РолиИсполнителей") Тогда
		
		ЕстьКартинка = Ложь;
		Фотография = РаботаСФотографиями.ПолучитьАдресФото(Контакт, УникальныйИдентификатор, ЕстьКартинка);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Фотография) Тогда
		Фотография = "";
		ЭтаФорма.Элементы.ГруппаСтраницыФотографии.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаКартинкаПоУмолчанию;
	Иначе	
		ЭтаФорма.Элементы.ГруппаСтраницыФотографии.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаФотография;
	КонецЕсли;	
	// фото пользователя
	
	ДополнительноеОписаниеКонтакта = "";
	ТипКонтакта = ТипЗнч(Контакт);
	
	Если ТипКонтакта = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		ДополнительноеОписаниеКонтакта = ОписаниеПодразделенияДляКарточки(Контакт);
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.Пользователи") Тогда
		ДополнительноеОписаниеКонтакта = ОписаниеПользователяДляКарточки(Контакт);
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.ЛичныеАдресаты") Тогда
		ДополнительноеОписаниеКонтакта = ОписаниеЛичногоАдресатаДляКарточки(Контакт);
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ДополнительноеОписаниеКонтакта = ОписаниеКонтактногоЛицаДляКарточки(Контакт);
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.Контрагенты") Тогда
		ДополнительноеОписаниеКонтакта = ОписаниеКонтрагентаДляКарточки(Контакт);
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		ДополнительноеОписаниеКонтакта = ОписаниеРолиДляКарточки(Контакт);
	КонецЕсли;
	
	Если ТипЗнч(ДополнительноеОписаниеКонтакта) = Тип("Строка") Тогда
		ОписаниеКонтакта = Новый ФорматированнаяСтрока(ДополнительноеОписаниеКонтакта);
	Иначе 
		ОписаниеКонтакта = ДополнительноеОписаниеКонтакта;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура НаписатьПисьмо()
	
	СписокПочтовыхАдресов = Новый СписокЗначений;
	
	ТекущиеДанные = Элементы.Получатели.ТекущиеДанные;
	
	АдресИнфо = Новый Структура("Контакт, Адрес, ОтображаемоеИмя",
		ТекущиеДанные.Контакт, ТекущиеДанные.Адрес, ТекущиеДанные.Представление);
		
	СписокПочтовыхАдресов.Добавить(АдресИнфо);
	
	ПараметрыОткрытия = Новый Структура("СписокПочтовыхАдресов", СписокПочтовыхАдресов);
	ОткрытьФорму("Документ.ИсходящееПисьмо.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонтакт(Команда)
	
	ТекущиеДанные = Элементы.Получатели.ТекущиеДанные;
	ПоказатьЗначение(,ТекущиеДанные.Контакт);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОписаниеПодразделенияДляКарточки(Контакт)
	
	Результат = "";
	
	Руководитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контакт, "Руководитель");
	Если ЗначениеЗаполнено(Руководитель) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			НСтр("ru='Руководитель: '") + Строка(Руководитель));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеПользователяДляКарточки(Контакт)
	
	Результат = "";
	
	СведенияПользователей = РегистрыСведений.СведенияОПользователяхДокументооборот.Получить(
		Новый Структура("Пользователь", Контакт));
	ОписаниеПользователяПодразделение = Строка(СведенияПользователей.Подразделение);
	
	Если ЗначениеЗаполнено(ОписаниеПользователяПодразделение) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			ОписаниеПользователяПодразделение);
	КонецЕсли;	
	
	Телефон = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.ТелефонПользователя,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(Телефон) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			НСтр("ru='Тел: '") + Телефон);
	КонецЕсли;
	
	АдресЭП = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.EmailПользователя,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(АдресЭП) Тогда
		
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + Символы.ПС;
		КонецЕсли;
		
		Результат = Новый ФорматированнаяСтрока(
			Результат, 
			НСтр("ru='E-mail: '"),
			Новый ФорматированнаяСтрока(АдресЭП, ,,, АдресЭП) );
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеРолиДляКарточки(Контакт)
	
	Результат = "";
	
	АдресЭП = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.EmailРоли,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(АдресЭП) Тогда
		
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + Символы.ПС;
		КонецЕсли;
		
		Результат = Новый ФорматированнаяСтрока(
			Результат, 
			НСтр("ru='E-mail: '"),
			Новый ФорматированнаяСтрока(АдресЭП, ,,, АдресЭП) );
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеЛичногоАдресатаДляКарточки(Контакт)
	
	Результат = "";
	
	Организация = Строка(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контакт, "Организация"));
	Если ЗначениеЗаполнено(Организация) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			Организация);
	КонецЕсли;		
	
	Должность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контакт, "Должность");
	Если ЗначениеЗаполнено(Должность) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			Должность);
	КонецЕсли;
	
	ТелефонКонтактногоЛица = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(ТелефонКонтактногоЛица) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			НСтр("ru='Тел: '") + ТелефонКонтактногоЛица);
	КонецЕсли;
	
	АдресЭП = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.EmailАдресата,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(АдресЭП) Тогда
		
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + Символы.ПС;
		КонецЕсли;
		
		Результат = Новый ФорматированнаяСтрока(
			Результат, 
			НСтр("ru='E-mail: '"),
			Новый ФорматированнаяСтрока(АдресЭП, ,,, АдресЭП) );
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеКонтактногоЛицаДляКарточки(Контакт)
	
	Результат = "";
	
	Должность = Строка(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контакт, "Должность"));
	Если ЗначениеЗаполнено(Должность) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			Должность);
	КонецЕсли;
	
	ТелефонКонтактногоЛица = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(ТелефонКонтактногоЛица) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			НСтр("ru='Тел: '") + ТелефонКонтактногоЛица);
	КонецЕсли;
	
	АдресЭП = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(АдресЭП) Тогда
		
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + Символы.ПС;
		КонецЕсли;
		
		Результат = Новый ФорматированнаяСтрока(
			Результат, 
			НСтр("ru='E-mail: '"),
			Новый ФорматированнаяСтрока(АдресЭП, ,,, АдресЭП) );
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеКонтрагентаДляКарточки(Контакт)
	
	Результат = "";
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контакт, "ЭтоГруппа") Тогда
		Возврат "";
	КонецЕсли;
	
	ТелефонКонтактногоЛица = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(ТелефонКонтактногоЛица) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат, 
			Символы.ПС, 
			НСтр("ru='Тел: '") + ТелефонКонтактногоЛица);
	КонецЕсли;
	
	АдресЭП = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.EmailКонтрагента,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(АдресЭП) Тогда
		
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + Символы.ПС;
		КонецЕсли;
		
		Результат = Новый ФорматированнаяСтрока(
			Результат, 
			НСтр("ru='E-mail: '"),
			Новый ФорматированнаяСтрока(АдресЭП, ,,, АдресЭП) );
		
	КонецЕсли;
	
	ФактическийАдрес = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		Контакт, 
		Справочники.ВидыКонтактнойИнформации.ФактическийАдресКонтрагента,,
		ТекущаяДатаСеанса());
		
	Если ЗначениеЗаполнено(ФактическийАдрес) Тогда
			
		Результат = Новый ФорматированнаяСтрока(
			Результат, 
			Символы.ПС, 
			НСтр("ru='Адрес: '") + ФактическийАдрес );
			
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти