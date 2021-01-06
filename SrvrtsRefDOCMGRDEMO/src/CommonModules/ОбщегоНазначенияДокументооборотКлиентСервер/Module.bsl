////////////////////////////////////////////////////////////////////////////////
// Общего назначения документооборот клиент сервер:
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текстовое представление единицы измерения в правильном склонении и числе
//
// Параметры
//  Число - Число - любое целое число.
//	ПараметрыПредметаИсчисления - Строка - варианты написания единицы измерения в родительном
//										   падеже для одной, для двух и для пяти единиц, разделитель
//										   - запятая. Пример: "минуту,минуты,минут".
//
// Возвращаемое значение
//  Строка - текстовое представление единицы измерения.
//
Функция ПредметИсчисленияПрописью(Знач Число, Знач ПараметрыПредметаИсчисления) Экспорт

	Результат = "";
	
	МассивПредставлений = Новый Массив;
	
	Позиция = Найти(ПараметрыПредметаИсчисления, ",");
	Пока Позиция > 0 Цикл
		Значение = СокрЛП(Лев(ПараметрыПредметаИсчисления, Позиция-1));
		ПараметрыПредметаИсчисления = Сред(ПараметрыПредметаИсчисления, Позиция + 1);
		МассивПредставлений.Добавить(Значение);
		Позиция = Найти(ПараметрыПредметаИсчисления, ",");
	КонецЦикла;
	
	Если СтрДлина(ПараметрыПредметаИсчисления) > 0 Тогда
		Значение = СокрЛП(ПараметрыПредметаИсчисления);
		МассивПредставлений.Добавить(Значение);
	КонецЕсли;	
	
	Если Число >= 100 Тогда
		Число = Число - Цел(Число / 100)*100;
	КонецЕсли;
	
	Если Число > 20 Тогда
		Число = Число - Цел(Число/10)*10;
	КонецЕсли;
	
	Если Число = 1 Тогда
		Результат = МассивПредставлений[0];
	ИначеЕсли Число > 1 И Число < 5 Тогда
		Результат = МассивПредставлений[1];
	Иначе
		Результат = МассивПредставлений[2];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает случайное число из указанного диапазона
// Параметры:
//  Минимум - Число - начало диапазона
//  Максимум - Число - конец диапазона
//  СчетчикГСЧ - Число - числовая переменная, которая сохраняет свое значение
//   между вызовами функции в случае, если интервал между вызовами небольшой (0-1 мс)
//  ВспомогательныйВызов - Булево - служебный параметр, заполнять не нужно
//  
Функция СлучайноеЧислоБезИспользованияГенератора(
		Минимум, Максимум, СчетчикГСЧ = 0, ВспомогательныйВызов = Ложь) Экспорт
	
	Результат = Минимум;
	
	Если Минимум < Максимум Тогда
		
		Делитель = 1;
		Если Не ВспомогательныйВызов Тогда
			Делители = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("2,3,5,7,11");
			Делитель = Делители[СлучайноеЧислоБезИспользованияГенератора(0, 4, СчетчикГСЧ, Истина)];
		КонецЕсли;
		
		Результат = Цел((ТекущаяУниверсальнаяДатаВМиллисекундах() + СчетчикГСЧ) / Делитель) % Максимум;
		
		Если Результат < Минимум Тогда
			Шаг = (Максимум - Минимум + 1);
			Результат = Результат + Шаг * Цел((Максимум - Результат) / Шаг);
		КонецЕсли;
		
	КонецЕсли;
	
	СчетчикГСЧ = СчетчикГСЧ + 13;
	
	Возврат Результат;
	
КонецФункции

// Показывает/скрывает кнопку очистки, если значение отбора заполнено/не заполнено.
//
// Параметры:
//   Поле     - ПолеФормы - элемент формы, в котором будет включена/выключена кнопка очистки.
//   Значение - ЛюбаяСсылка - значение отбора.
//   ЗначениеПоУмолчанию - ЛюбаяСсылка - значение по умолчанию, на которое не нужно накладывать оформление.
//
Процедура ПоказатьСкрытьКнопкуОчисткиОтбора(Поле, Значение, ЗначениеПоУмолчанию = "") Экспорт
	
	Если ТипЗнч(Поле) <> Тип("ПолеФормы") Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Значение) Тогда 
		Если Не ЗначениеЗаполнено(ЗначениеПоУмолчанию)
			Или (ЗначениеЗаполнено(ЗначениеПоУмолчанию) И Значение <> ЗначениеПоУмолчанию) Тогда 
			Поле.КнопкаОчистки = Истина;
			#Если Клиент Тогда
				Поле.ЦветФона = ОбщегоНазначенияКлиент.ЦветСтиля("ФонУправляющегоПоля");
			#Иначе
				Поле.ЦветФона = ЦветаСтиля["ФонУправляющегоПоля"];
			#КонецЕсли
		Иначе 
			Поле.КнопкаОчистки = Ложь;
			Поле.ЦветФона = Новый Цвет();
		КонецЕсли;
	Иначе 
		Поле.КнопкаОчистки = Ложь;
		Поле.ЦветФона = Новый Цвет();
	КонецЕсли;
	
КонецПроцедуры

// Выделяет из имени файла его имя (набор символов до последней точки).
//
// Параметры:
//  ИмяФайла - Строка - имя файла с именем каталога или без.
//
// Возвращаемое значение:
//   Строка - имя файла.
//
Функция ПолучитьТолькоИмяИмениФайла(Знач ИмяФайла) Экспорт
	
	ТолькоИмя = "";
	
	ПозицияСимвола = СтрДлина(ИмяФайла);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИмяФайла, ПозицияСимвола, 1) = "." Тогда
			
			ТолькоИмя = Лев(ИмяФайла, ПозицияСимвола - 1);
			Прервать;
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;
	КонецЦикла;

	Возврат ТолькоИмя;
	
КонецФункции

// Устанавливает отбор списка.
//
// Параметры:
//  Список - ДинамическийСписок - Список, для которого нужно установить отбор.
//  ИмяПараметра - Строка - Имя параметра списка.
//  ЗначениеОтбора - Произвольный - Значение отбора.
//  ПолеОтбора - ПолеФормы - Элемент формы, соответсвующий отбору.
//
Процедура УстановитьОтборСписка(Список, ИмяПараметра, ЗначениеОтбора, ПолеОтбора) Экспорт
	
	Параметр = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Параметр.Использование = Ложь;
	Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
		Список.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеОтбора);
	КонецЕсли;
	
	ПоказатьСкрытьКнопкуОчисткиОтбора(ПолеОтбора, ЗначениеОтбора);
	
КонецПроцедуры

// Устанавливает отбор показа удаленных.
//
// Параметры:
//  Список - ДинамическийСписок - Список, для которого нужно установить отбор.
//  ПоказыватьУдаленные - Булево - Параметр показывать удаленные.
//  Команда - КомандаФормы - Команда "Показывать удаленные".
//
Процедура УстановитьОтборПоказыватьУдаленные(Список, ПоказыватьУдаленные, Команда) Экспорт
	
	Параметр = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПоказыватьУдаленные"));
	Параметр.Использование = Ложь;
	Если Не ПоказыватьУдаленные Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУдаленные", Ложь);
	КонецЕсли;
	
	Команда.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

// Определяет, есть ли какие-то отличия в таблицах, выполняя поэлементное сравнение.
// 
// Параметры:
//  Таблица1 - Коллекция.
//  Таблица2 - Коллекция.
//  ПоляДляСравнения - Строка - список полей, разделенных запятыми.
// 
// Возвращаемое значение:
//  Булево - признак того, что коллекции отличаются.
//
Функция ЕстьОтличияВТаблицах(Таблица1, Таблица2, ПоляДляСравнения) Экспорт
	
	КоличествоЗаписей = Таблица1.Количество();
	ЕстьОтличия = КоличествоЗаписей <> Таблица2.Количество();
	
	Если Не ЕстьОтличия Тогда
		
		ПоляДляСравнения = СтрРазделить(ПоляДляСравнения, ",");
		Для Сч = 0 По КоличествоЗаписей - 1 Цикл
			Для Каждого Эл Из ПоляДляСравнения Цикл
				ИмяПоля = СокрЛП(Эл);
				Если Таблица1[Сч][ИмяПоля] <> Таблица2[Сч][ИмяПоля] Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ЕстьОтличия;
 	
КонецФункции

// Определяет, есть ли какие-то отличия в массива, выполняя поэлементное сравнение.
// 
// Параметры:
//  Массив1 - Коллекция.
//  Массив2 - Коллекция.
// 
// Возвращаемое значение:
//  Булево - признак того, что коллекции отличаются.
//
Функция ЕстьОтличияВМассивах(Массив1, Массив2) Экспорт
	
	КоличествоЗаписей = Массив1.Количество();
	ЕстьОтличия = КоличествоЗаписей <> Массив2.Количество();
	
	Если Не ЕстьОтличия Тогда
		
		Для Сч = 0 По КоличествоЗаписей - 1 Цикл
			Если Массив1[Сч] <> Массив2[Сч] Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ЕстьОтличия;
 	
КонецФункции

#Область РаботаСДеревом

// Выполняет переданный код для всех строк дерева или его ветки.
//
// Параметры:
//  Ветка - ДанныеФормыДерево, ДанныеФормыЭлементДерева - дерево или его элемент.
//  Код - Строка - код, который нужно выполнить для каждой строки дерева или его ветки.
//      В коде могут использовать переменные: 
//      ТекущаяСтрока - для работы с текущей строкой дерева.
//      ПрерватьОбработку - для установки признака прерывания цикла.
//                                        
//  ДопПараметры - Структура, Неопределено - дополнительные параметры, которые могут использоваться в коде.
//
Процедура ВыполнитьДействиеДляВсехСтрокДерева(Ветка, Код, ДопПараметры = Неопределено) Экспорт
	
	СтрокиКОбработке = Новый Массив;
	Для Каждого Строка Из Ветка.ПолучитьЭлементы() Цикл
		СтрокиКОбработке.Добавить(Строка);
	КонецЦикла;
	
	ПрерватьОбработку = Ложь;
	Пока СтрокиКОбработке.Количество() > 0 И Не ПрерватьОбработку Цикл
		
		ТекущаяСтрока = СтрокиКОбработке[0];
		СтрокиКОбработке.Удалить(0);
		
		Выполнить(Код);
		
		Для Каждого Строка Из ТекущаяСтрока.ПолучитьЭлементы() Цикл
			СтрокиКОбработке.Добавить(Строка);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет поиск строк дерева в соответствии с переданным отбором.
//
// Параметры:
//  Ветка - ДанныеФормыДерево, ДанныеФормыЭлементДерева - дерево или его элемент, 
//          в рамках которых выполняется поиск.
//  СтруктураОтбора - Структура - структура, по значениям которой будет выполняться поиск.
//
// Возвращаемое значение:
//   Массив - массив найденных строк.
//
Функция НайтиСтрокиДерева(Ветка, СтруктураОтбора) Экспорт
	
	Возврат НайтиСтрокиВеткиДереваПоОтбору(Ветка, СтруктураОтбора, Ложь);
	
КонецФункции

// Выполняет поиск первой строки дерева в соответствии с переданным отбором.
//
// Параметры:
//  Ветка - ДанныеФормыДерево, ДанныеФормыЭлементДерева - дерево или его элемент, 
//          в рамках которых выполняется поиск.
//  СтруктураОтбора - Структура - структура, по значениям которой будет выполняться поиск.
//
// Возвращаемое значение:
//   ДанныеФормыЭлементДерева - найденная строка.
//
Функция НайтиСтрокуДерева(Ветка, СтруктураОтбора) Экспорт
	
	Результат = Неопределено;
	
	НайденныеСтроки = НайтиСтрокиВеткиДереваПоОтбору(Ветка, СтруктураОтбора, Истина);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Результат = НайденныеСтроки[0];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает массив всех строк дерева или его ветки.
//
// Параметры:
//  Ветка - ДанныеФормыДерево, ДанныеФормыЭлементДерева - дерево или его элемент,
//    строки которого нужно получить.
//
// Возвращаемое значение:
//   Массив - массив строк дерева.
//
Функция ВсеСтрокиДерева(Ветка) Экспорт
	
	Результат = Новый Массив;
	
	ДопПараметры = Новый Структура("Результат", Результат);
	ВыполняемыйКод = "ДопПараметры.Результат.Добавить(ТекущаяСтрока)";
	ВыполнитьДействиеДляВсехСтрокДерева(Ветка, ВыполняемыйКод, ДопПараметры);
	
	Возврат Результат;
	
КонецФункции

// Заполняет колонки всех строк дерева или его ветки переданными значениями.
//
// Параметры:
//  Ветка - ДанныеФормыДерево, ДанныеФормыЭлементДерева - дерево или его элемент.
//  ЗначенияДляЗаполнения - Структура - значения, которыми нужно заполнить колонки дерева.
//
Процедура ЗаполнитьКолонкиДерева(Ветка, ЗначенияДляЗаполнения) Экспорт
	
	ДопПараметры = Новый Структура("ЗначенияДляЗаполнения", ЗначенияДляЗаполнения);
	ВыполняемыйКод = "ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДопПараметры.ЗначенияДляЗаполнения)";
	ВыполнитьДействиеДляВсехСтрокДерева(Ветка, ВыполняемыйКод, ДопПараметры);
	
КонецПроцедуры

#КонецОбласти

// Возвращает копию массива, не обходя его элементы рекурсивно, в отличие от
// ОбщегоНазначенияКлиентСервер.СкопироватьМассив().
// Поэтому функцию следует использовать для копирования массивов без слоных вложенных конструкций
// (вложенные массивы, таблицы значений, соотвествия, струкутры, списки значений и т.д.).
//
// Параметры:
//   Массив - Массив - копируемый массив.
//
// Возвращаемое значение:
//   Массив - копия исходного массива.
//
Функция ПростаяКопияМассива(Массив) Экспорт
	
	Копия = Новый Массив;
	Для Каждого Элемент Из Массив Цикл
		Копия.Добавить(Элемент);
	КонецЦикла;
	
	Возврат Копия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиСтрокиВеткиДереваПоОтбору(Ветка, СтруктураОтбора, ТолькоПерваяСтрока)
	
	Результат = Новый Массив;
	
	СтрокиКОбработке = Новый Массив;
	Для Каждого Строка Из Ветка.ПолучитьЭлементы() Цикл
		СтрокиКОбработке.Добавить(Строка);
	КонецЦикла;
	
	Пока СтрокиКОбработке.Количество() > 0 Цикл
		
		ТекущаяСтрока = СтрокиКОбработке[0];
		СтрокиКОбработке.Удалить(0);
		
		ЕстьОтличия = Ложь;
		Для Каждого КлючИЗначение Из СтруктураОтбора Цикл
			Если ТекущаяСтрока[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
				ЕстьОтличия = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЕстьОтличия Тогда
			Результат.Добавить(ТекущаяСтрока);
			Если ТолькоПерваяСтрока Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Для Каждого Строка Из ТекущаяСтрока.ПолучитьЭлементы() Цикл
			СтрокиКОбработке.Добавить(Строка);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
