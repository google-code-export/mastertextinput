/***************************************
Copyright (c) 2008 juliano.mendes@flexpernambuco.com.br
 				   http://www.flexpernambuco.com.br
 				   http://code.google.com/p/mastertextinput/

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************/

/*****************************************
VERSION CONTROL:

- v0.1 - 16/10/2008 - Juliano Mendes:
 * CapsType : Upper, Lower, Init
 * ClearButton
 * Auto Validation : Email, Phone, Date, Number, String
 * OnlyRestrict : Number, Alpha, AlphaNoSpecial
 * NextFocusOnEnter
 * 
- v0.2 - 17/10/2008 - Juliano Mendes:
 * InputMask Implementation

******************************************/
package com.flexpernambuco.controls
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;
	import mx.validators.DateValidator;
	import mx.validators.EmailValidator;
	import mx.validators.NumberValidator;
	import mx.validators.PhoneNumberValidator;
	import mx.validators.StringValidator;
	import mx.validators.Validator;

    /**
     *  @events
     */
	[Event( name="enterPressed", type="flash.events.Event" )]


[IconFile("mastertextinput.png")]
public class MasterTextInput extends TextInput
{

    /**
     *  @private
     */
	// ENTER KEY Code
	private var _keyCode:uint=13;			
	// Validations vars
	private var emailValidator:EmailValidator; 
    private var phoneValidator:PhoneNumberValidator;
    private var stringValidator:StringValidator;
    private var numberValidator:NumberValidator;
    private var dateValidator:DateValidator;
	// store current language index for validation 0 - Portuguese 1 - English 2 - Spanish
	//[Bindable]
	private var _currentLanguage:int = 0;
	// Clear Button Object
	private var clearButton:Button;

    /**
     *  @constants
     */
	// Contants - Property capsType
	public const CAPS_NORMAL:String = 'normal'; // Normal Text [DEFAULT]
	public const CAPS_LOWERCASE:String = 'lowercase'; // Auto-Change to lowerCase
	public const CAPS_UPPERCASE:String = 'upercase'; // Auto-Change to upperCase
	public const CAPS_INIT:String = 'init'; // Auto-Change to Inital Char to upperCase
	// Contants - Property onlyRestrict
	public const ONLY_NONE:String = 'none'; // No restrict [DEFAULT]
	public const ONLY_NUMBER:String = 'number'; // Only number
	public const ONLY_TEXT:String = 'alphabetic'; // Only Alpha
	public const ONLY_TEXT_NO_SPECIAL:String = 'alphabeticNoSpecial'; // Only alpha withou special caracters
	// Contants - Property validationLanguage
	public const LANG_PT_BR:String = 'portuguese'; // [DEFAULT]	     
	public const LANG_ENG:String = 'english';	     
	public const LANG_SPA:String = 'spanish';	     
	// Contants - Property validator
	public const VALIDATOR_NONE:String = 'none'; // No validation [DEFAULT]	     
	public const VALIDATOR_EMAIL:String = 'email';  // E-mail validation
	public const VALIDATOR_PHONE:String = 'phone'; // Phone Number validation
	public const VALIDATOR_STRING:String = 'string'; // String validation
	public const VALIDATOR_NUMBER:String = 'number'; // Number validation
	public const VALIDATOR_DATE:String = 'date'; // Date validation
	// Contants - Clear Button Constant
	[Embed(source="../assets/icon_close10.png")]
	public const CLEAR_BUTTON_ICON:Class;

    /**
     *  @public
     */
    // Indicate the Current Validator Object
    [Bindable]
    public var currentValidator:Validator = null;

    /**
     *  @constructor
     */
	public function MasterTextInput()
	{
		super();

		// Verify if ENTER KEY was pressed
        this.addEventListener(KeyboardEvent.KEY_UP,handleKeyboardEnter);
        // Event Change
        this.addEventListener(Event.CHANGE,textChange);
        // Event Creation Complete
        this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);

		// Events to Mask Input
		this.addEventListener(FocusEvent.FOCUS_IN, maskFocusInHandler)
		this.addEventListener(FocusEvent.FOCUS_OUT, maskFocusOutHandler)
		this.addEventListener(KeyboardEvent.KEY_DOWN, maskSetPosition);
		this.addEventListener(MouseEvent.MOUSE_DOWN, maskSetPosition);
		this.addEventListener(MouseEvent.MOUSE_MOVE, maskSetPosition);
	}

    /**
     *  Auto execute validations properties
     */
	private function creationComplete(event:Event):void
	{
		addClearButton(null);
		initMask(null);
		maskFocusInHandler(null);
		//validator = _validator;
	}
    
	/**
	* Event handler function for KeyBoard events from this instance.
	*/
    protected function handleKeyboardEnter(event:KeyboardEvent):void
    {
        if (event.keyCode==this._keyCode)
        {
			// Dispatch ENTER PRESSED Event
            var newEvent:Event = new Event("enterPressed",false);
            dispatchEvent(newEvent);

            if (_nextFocusOnEnter==true) {
				var fm:IFocusManager = this.focusManager;
	            var next:IFocusManagerComponent = fm.getNextFocusManagerComponent();
	            fm.setFocus(next);
            	
            } 
        }
    }

	/**
	 * @public 
	 * CAPS TYPE PROPERTY:
	 * Auto change the text case.
	 * NORMAL : No change [DEFAULT]
	 * LOWERCASE : Auto change to lowercase
	 * UPPERCASE : Auto change to uppercase
	 * INIT : Auto change first char to uppercase
	*/
	private var _capsType:String = CAPS_NORMAL;
	[Inspectable(enumeration="normal,lowercase,upercase,init", defaultValue="normal",category="General")]
	public function get capsType():String
	{
		return _capsType;
	}
	public function set capsType(value:String):void
	{
		switch (value)
		{
			case CAPS_NORMAL:
			{
				break;
			}
			case CAPS_LOWERCASE:
			{
				this.text = this.text.toLowerCase();
				break;
			}
			case CAPS_UPPERCASE:
			{
				this.text = this.text.toUpperCase();
				break;
			}
			case CAPS_INIT:
			{
				if (this.text!=null && this.text!="") 
				{this.text = getInitCap(this.text);}
				break;
			}
			default:
			{
	
			var message:String = resourceManager.getString("rpc", "invalidResultFormat",[ value,
				CAPS_NORMAL,CAPS_LOWERCASE,CAPS_UPPERCASE,CAPS_INIT]);
			throw new ArgumentError(message);
			}
		}

		_capsType = value;
	}

	/**
	 * @private
	 * TEXT CHANGE:
	 * Make text changes - Caps
	*/
	private function textChange(event:Event):void
	{
		// Show Clear Button
		if (_showClearButton == true)
		{ showButton(null); 
		}
		
		switch (this._capsType)
		{
			case CAPS_NORMAL:
			{
				break;
			}
			case CAPS_LOWERCASE:
			{
				this.text = this.text.toLowerCase();
				break;
			}
			case CAPS_UPPERCASE:
			{
				this.text = this.text.toUpperCase();
				break;
			}
			case CAPS_INIT:
			{
				if (this.text!=null && this.text!="") 
				{this.text = getInitCap(this.text);}
				break;
			}
			default:
			{
			}
		}
   	 
   	    maskTextChanged(null);
		
	}

	/**
	 * @private
	 * GET INIT CAP:
	 * Tranfor all first chars of words to UpperCase
	*/
	private function getInitCap(value:String):String
	{
		var _return:String = "";
		var lastChar:String = " ";
		
		for (var i:int = 0; i<value.length; i++) 
		{
		  if (lastChar == " ") 
		  {
		  	_return += value.charAt(i).toUpperCase();
		  }	else {
		  	_return += value.charAt(i).toLowerCase();
		  }
		  lastChar = value.charAt(i);
		}
		
		return _return;
	}

	/**
	 * @public 
	 * ONLY RESTRICT PROPERTY:
	 * Restrict caracteres.
	 * NONE : No change [DEFAULT]
	 * NUMBER : Only number [0-9]
	 * ALPHABETIC : Only text [^0-9]
	 * ALPHABETICNOSPECIAL : Only text and no special caracteres [^0-9`~!@#$%&*()-_+=[]{}\\|;:/?>.<,\^]
	*/
	private var _onlyRestrict:String = ONLY_NONE;
	[Inspectable(enumeration="none,number,alphabetic,alphabeticNoSpecial", defaultValue="none",category="General")]
	public function get onlyRestrict():String
	{
		return _onlyRestrict;
	}
	public function set onlyRestrict(value:String):void
	{
		switch (value)
		{
			case ONLY_NONE:
			{
				break;
			}
			case ONLY_NUMBER:
			{
				this.restrict = "0-9";
				break;
			}
			case ONLY_TEXT:
			{
				this.restrict = "^0-9";
				break;
			}
			case ONLY_TEXT_NO_SPECIAL:
			{
				this.restrict = "^0-9`~!@#$%&*()-_+=[]{}\\|;:/?>.<,\^";
				break;
			}
			default:
			{
	
			var message:String = resourceManager.getString("rpc", "invalidResultFormat",[ value,
				ONLY_NONE,ONLY_NUMBER,ONLY_TEXT,ONLY_TEXT_NO_SPECIAL]);
			throw new ArgumentError(message);
			}
		}
		_onlyRestrict = value;
	}

	/**
	 * @public 
	 * VALIDATION LANGUAGE PROPERTY:
	 * Indicate the Language of Validation Errors.
	 * PORTUGUESE : Errors text in portugues [DEFAULT]
	 * ENGLISH : Errors text in ingles
	 * SPANISH : Errors text in Espanhol
	*/
	private var _validationLanguage:String = LANG_PT_BR;
	[Inspectable(enumeration="portuguese,english,spanish", defaultValue="portuguese",category="General")]
	public function get validationLanguage():String
	{
		return _validationLanguage;
	}
	public function set validationLanguage(value:String):void
	{
		switch (value)
		{
			case LANG_PT_BR:
			{
				_currentLanguage = 0;
				break;
			}
			case LANG_ENG:
			{
				_currentLanguage = 1;
				break;
			}
			case LANG_SPA:
			{
				_currentLanguage = 2;
				break;
			}
			default:
			{
				var message:String = resourceManager.getString("rpc", "invalidResultFormat",[ value,
					LANG_PT_BR,LANG_ENG,LANG_SPA]);
				throw new ArgumentError(message);
			}
		}
		_validationLanguage = value;
		validator = _validator;
	}

	/**
	 * @public 
	 * VALIDATOR PROPERTY:
	 * Indicate the active validation.
	 * NONE : No validation [DEFAULT]
	 * EMAIL : E-mail validation
	 * PHONE : Phone Number validation
	 * STRING : String validation
	 * NUMBER : Number validation
	 * DATE : Date validation
	*/
	private var _validator:String = VALIDATOR_NONE;
	[Inspectable(enumeration="none,email,phone,string,number,date", defaultValue="none",category="General")]
	public function get validator():String
	{
		return _validator;
	}
	public function set validator(value:String):void
	{
		emailValidator = null;
		phoneValidator = null;
		stringValidator = null;
		numberValidator = null;
		dateValidator = null;
		currentValidator = null;

		switch (value)
		{
			case VALIDATOR_NONE:
			{
				break;
			}
			case VALIDATOR_EMAIL:
			{
				setEmailValidator();
				break;
			}
			case VALIDATOR_PHONE:
			{
				setPhoneValidator();
				break;
			}
			case VALIDATOR_STRING:
			{
				setStringValidator();
				break;
			}
			case VALIDATOR_NUMBER:
			{
				setNumberValidator();
				break;
			}
			case VALIDATOR_DATE:
			{
				setDateValidator();
				break;
			}
			default:
			{
				var message:String = resourceManager.getString("rpc", "invalidResultFormat",[ value,
					VALIDATOR_DATE,VALIDATOR_EMAIL,VALIDATOR_NONE,VALIDATOR_NUMBER, VALIDATOR_PHONE, VALIDATOR_STRING]);
				throw new ArgumentError(message);
			}
		}

		_validator = value;
	}

	/**
	 * @private
	 * SetEmailValidator:
	 * Active the E-MAIL Validation
	*/
	private function setEmailValidator():void
	{
		emailValidator = new EmailValidator();
		emailValidator.source = this;
		emailValidator.property = "text";
		emailValidator.trigger = _trigger;
		emailValidator.triggerEvent = _triggerEvent;
		emailValidator.required = _required;
		emailValidator.requiredFieldError = ValidatorError.EMAIL_REQUIRED_FIELD_ERROR[_currentLanguage];
        emailValidator.invalidCharError = ValidatorError.EMAIL_INVALID_CHAR_ERROR[_currentLanguage];
        emailValidator.invalidDomainError = ValidatorError.EMAIL_INVALID_DOMAIN_ERROR[_currentLanguage];
        emailValidator.invalidIPDomainError = ValidatorError.EMAIL_INVALID_IP_DOMAIN_ERROR[_currentLanguage];
        emailValidator.invalidPeriodsInDomainError = ValidatorError.EMAIL_INVALID_PERIODS_IN_DOMAIN_ERROR[_currentLanguage];
        emailValidator.missingAtSignError = ValidatorError.EMAIL_MISSING_AT_SIGN_ERROR[_currentLanguage];
        emailValidator.missingPeriodInDomainError = ValidatorError.EMAIL_MISSING_PERIOD_IN_DOMAIN_ERROR[_currentLanguage];
        emailValidator.missingUsernameError = ValidatorError.EMAIL_MISSING_USERNAME_ERROR[_currentLanguage];
        emailValidator.tooManyAtSignsError = ValidatorError.EMAIL_TOO_MANY_AT_SIGNS_ERROR[_currentLanguage]
        currentValidator = emailValidator;
        //this.validateProperties();
	}

	/**
	 * @private
	 * SetPhoneValidator:
	 * Active the PHONE NUMBER Validation
	*/
	private function setPhoneValidator():void
	{
		phoneValidator = new PhoneNumberValidator();
		phoneValidator.source = this;
		phoneValidator.property = "text";
		phoneValidator.trigger = _trigger;
		phoneValidator.triggerEvent = _triggerEvent;
		phoneValidator.required = _required;
		phoneValidator.requiredFieldError = ValidatorError.PHONE_REQUIRED_FIELD_ERROR[_currentLanguage];
        phoneValidator.invalidCharError = ValidatorError.PHONE_INVALID_CHAR_ERROR[_currentLanguage];
        phoneValidator.wrongLengthError = ValidatorError.PHONE_WRONG_LENGTH_ERROR[_currentLanguage];
        if (_allowedFormatCharsChange == false)
        {
        	_allowedFormatChars = "() -";
        }
        phoneValidator.allowedFormatChars = _allowedFormatChars;
        currentValidator = phoneValidator;
        //this.validateProperties();
	}

	/**
	 * @private
	 * SetDateValidator:
	 * Active the DATE Validation
	*/
	private function setDateValidator():void
	{
		dateValidator = new DateValidator();
		dateValidator.source = this;
		dateValidator.property = "text";
		dateValidator.trigger = _trigger;
		dateValidator.triggerEvent = _triggerEvent;
		dateValidator.required = _required;
		dateValidator.requiredFieldError = ValidatorError.DATE_REQUIRED_FIELD_ERROR[_currentLanguage];
        dateValidator.formatError = ValidatorError.DATE_FORMAT_ERROR[_currentLanguage] + _inputFormat;
        dateValidator.invalidCharError = ValidatorError.DATE_INVALID_CHAR_ERROR[_currentLanguage];
        dateValidator.wrongDayError = ValidatorError.DATE_WRONG_DAY_ERROR[_currentLanguage];
        dateValidator.wrongLengthError = ValidatorError.DATE_WRONG_LENGTH_ERROR[_currentLanguage];
        dateValidator.wrongMonthError = ValidatorError.DATE_WRONG_MONTH_ERROR[_currentLanguage];
        dateValidator.wrongYearError = ValidatorError.DATE_WRONG_YEAR_ERROR[_currentLanguage];
        if (_allowedFormatCharsChange == false)
        {
        	_allowedFormatChars = "/\-. ";
        }
        dateValidator.allowedFormatChars = _allowedFormatChars;
        dateValidator.inputFormat = _inputFormat;
        currentValidator = dateValidator;
        //this.validateProperties();
	}

	/**
	 * @private
	 * SetStringValidator:
	 * Active the STRING Validation
	*/
	private function setStringValidator():void
	{
		stringValidator = new StringValidator();
		stringValidator.source = this;
		stringValidator.property = "text";
		stringValidator.trigger = _trigger;
		stringValidator.triggerEvent = _triggerEvent;
		stringValidator.required = _required;
		stringValidator.requiredFieldError = ValidatorError.STRING_REQUIRED_FIELD_ERROR[_currentLanguage];
        stringValidator.tooLongError = ValidatorError.STRING_TOO_LONG_ERROR[_currentLanguage] + _maxLength + ValidatorError.STRING_TOO_LONG_ERROR_CHAR[_currentLanguage];
        stringValidator.tooShortError = ValidatorError.STRING_TOO_SHORT_ERROR[_currentLanguage] + _minLength + ValidatorError.STRING_TOO_SHORT_ERROR_CHAR[_currentLanguage];
        stringValidator.maxLength = _maxLength;
        stringValidator.minLength = _minLength;
        currentValidator = stringValidator;
        //this.validateProperties();
	}

	/**
	 * @private
	 * SetNumberValidator:
	 * Active the NUMBER validation
	*/
	private function setNumberValidator():void
	{
		numberValidator = new NumberValidator();
		numberValidator.source = this;
		numberValidator.property = "text";
		numberValidator.trigger = _trigger;
		numberValidator.triggerEvent = _triggerEvent;
		numberValidator.required = _required;
		numberValidator.allowNegative = _allowNegative;
		numberValidator.decimalSeparator = _decimalSeparator;
		numberValidator.domain = _domain;
		numberValidator.maxValue = _maxValue;
		numberValidator.minValue = _minValue;
		numberValidator.precision = _precision;
		numberValidator.thousandsSeparator = _thousandsSeparator;
		numberValidator.requiredFieldError = ValidatorError.NUMBER_REQUIRED_FIELD_ERROR[_currentLanguage];
        numberValidator.decimalPointCountError = ValidatorError.NUMBER_DECIMAL_POINT_COUNT_ERROR[_currentLanguage];
        numberValidator.exceedsMaxError = ValidatorError.NUMBER_EXCEEDS_MAX_ERROR[_currentLanguage];
        numberValidator.integerError = ValidatorError.NUMBER_INTEGER_ERROR[_currentLanguage];
        numberValidator.invalidCharError = ValidatorError.NUMBER_INVALID_CHAR_ERROR[_currentLanguage];
        numberValidator.invalidFormatCharsError = ValidatorError.NUMBER_INVALID_FORMAT_CHARS_ERROR[_currentLanguage];
        numberValidator.lowerThanMinError = ValidatorError.NUMBER_LOWER_THAN_MIN_ERROR[_currentLanguage];
        numberValidator.negativeError = ValidatorError.NUMBER_NEGATIVE_ERROR[_currentLanguage];
        numberValidator.precisionError = ValidatorError.NUMBER_PRECISION_ERROR[_currentLanguage];
        numberValidator.separationError = ValidatorError.NUMBER_SEPARATION_ERROR[_currentLanguage];
        currentValidator = numberValidator;
        //this.validateProperties();
	}

	/**
	 * @public
	 * NEXT FOCUS ON ENTER PROPERTY:
	 * Auto focus to next component on press Enter Key.
	 * TRUE : Enabled
	 * FALSE : Disabled [DEFAULT]
	*/
	private var _nextFocusOnEnter:Boolean = false;
	[Inspectable(defaultValue="false",category="Boolean")]
	public function get nextFocusOnEnter():Boolean
	{
		return _nextFocusOnEnter;
	}
	public function set nextFocusOnEnter(value:Boolean):void
	{
		this._nextFocusOnEnter = value;
	}


    /**
     *  @private
     *  Storage for the trigger property.
     */
    private var _trigger:IEventDispatcher;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the component generating the event that triggers the validator. 
     *  If omitted, by default Flex uses the value of the <code>source</code> property.
     *  When the <code>trigger</code> dispatches a <code>triggerEvent</code>,
     *  validation executes. 
     */
    public function get trigger():IEventDispatcher
    {
        return _trigger;
    }
    
    /**
     *  @private
     */
    public function set trigger(value:IEventDispatcher):void
    {
        //removeTriggerHandler();
        _trigger = value;
        validator = _validator;
        //currentValidator.trigger = _trigger;
        //addTriggerHandler();    
    }
    
    //----------------------------------
    //  triggerEvent
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the triggerEvent property.
     */
    private var _triggerEvent:String = FlexEvent.VALUE_COMMIT;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the event that triggers the validation. 
     *  If omitted, Flex uses the <code>valueCommit</code> event. 
     *  Flex dispatches the <code>valueCommit</code> event
     *  when a user completes data entry into a control.
     *  Usually this is when the user removes focus from the component, 
     *  or when a property value is changed programmatically.
     *  If you want a validator to ignore all events,
     *  set <code>triggerEvent</code> to the empty string ("").
     */
    public function get triggerEvent():String
    {
        return _triggerEvent;
    }
    
    /**
     *  @private
     */
    public function set triggerEvent(value:String):void
    {
        if (_triggerEvent == value)
            return;
            
        //removeTriggerHandler();
        _triggerEvent = value;
        //addTriggerHandler();
        validator = _validator;
        //currentValidator.triggerEvent = _triggerEvent;
    }

	/**
	 *  @public
	 *  Storage for the required property.
	 *  Used in validation
	 */
	//[Bindable]
	private var _required:Boolean = true;
	[Inspectable(defaultValue="false",category="Boolean")]
	public function get required():Boolean
	{
		return _required;
	}
	public function set required(value:Boolean):void
	{
		this._required = value;
		//currentValidator.required = this._required;
		validator = _validator;
	}


	/**
	 *  @private
	 *  Storage for the allowedFormatChars property.
	 *  Used for DATE AND PHONE VALIDATION
	 */
	private var _allowedFormatCharsChange:Boolean = false;
	private var _allowedFormatChars:String;
	[Inspectable(category="General", defaultValue="")]
	public function get allowedFormatChars():String
	{
		return _allowedFormatChars;
	}
	public function set allowedFormatChars(value:String):void
	{
		_allowedFormatChars = value;
		_allowedFormatCharsChange = true;
		validator = _validator;
	}

	/**
	 *  @private
	 *  Storage for the allowedFormatChars property.
	 *  Used for DATE VALIDATION
	 *  DD/MM/YYYY : DEFAULT Format
	 */
	private var _inputFormat:String = "DD/MM/YYYY";
	[Inspectable(category="General", defaultValue="DD/MM/YYYY")]
	public function get inputFormat():String
	{
		return _inputFormat;
	}
	public function set inputFormat(value:String):void
	{
		_inputFormat = value;
		validator = _validator;
	}

	/**
	 *  @private
	 *  Storage for the maxLength property.
	 *  Used for STRING VALIDATION
	 */
	private var _maxLength:Object;
	private var maxLengthOverride:Object;
	[Inspectable(category="General", defaultValue="null")]
	/** 
	 *  Maximum length for a valid String. 
	 *  A value of NaN means this property is ignored.
	 *
	 *  @default NaN
	 */
	public function get maxLength():Object
	{
		return _maxLength;
	}
	public function set maxLength(value:Object):void
	{
		maxLengthOverride = value;
	
		_maxLength = value != null ?
					 Number(value) :
					 resourceManager.getNumber(
					     "validators", "maxLength");
	    validator = _validator;
	}

	/**
	 *  @private
	 *  Storage for the minLength property.
	 *  Used for STRING VALIDATION
	 */
	private var _minLength:Object;
	private var minLengthOverride:Object;
	[Inspectable(category="General", defaultValue="null")]
	/** 
	 *  Minimum length for a valid String.
	 *  A value of NaN means this property is ignored.
	 *
	 *  @default NaN
	 */
	public function get minLength():Object
	{
		return _minLength;
	}
	/**
	 *  @private
	 */
	public function set minLength(value:Object):void
	{
		minLengthOverride = value;
	
		_minLength = value != null ?
					 Number(value) :
					 resourceManager.getNumber(
					     "validators", "minLength");
	    validator = _validator;
	}

    /**
	 *  @private
	 *  Storage for the maxLength property.
	 *  Used in NUMBER VALIDATION
	 */
	private var _maxValue:Object;
	private var maxValueOverride:Object;
	[Inspectable(category="General", defaultValue="null")]
	/** 
	 *  Maximum value for a valid Number. 
	 *  A value of NaN means this property is ignored.
	 *
	 *  @default NaN
	 */
	public function get maxValue():Object
	{
		return _maxValue;
	}
	public function set maxValue(value:Object):void
	{
		maxValueOverride = value;
		_maxValue = value != null ?
					 Number(value) :
					 resourceManager.getNumber(
					     "validators", "maxValue");
        validator = _validator;
	}
	
    /**
	 *  @private
	 *  Storage for the minValue property.
	 *  Used in NUMBER VALIDATION
	 */
	private var _minValue:Object;
	private var minValueOverride:Object;
	[Inspectable(category="General", defaultValue="null")]
	/** 
	 *  Minimum Value for a valid Number. 
	 *  A value of NaN means this property is ignored.
	 *
	 *  @default NaN
	 */
	public function get minValue():Object
	{
		return _minValue;
	}
	public function set minValue(value:Object):void
	{
		minValueOverride = value;
		_minValue = value != null ?
					 Number(value) :
					 resourceManager.getNumber(
					     "validators", "minValue");
        validator = _validator;
	}

    /**
	 *  @private
	 *  Storage for the thousandsSeparator property.
	 *  USED IN NUMBER VALIDATION
	 */
	private var _thousandsSeparator:String = ".";
	private var thousandsSeparatorOverride:String;
    [Inspectable(category="General", defaultValue=".")]
    /**
     *  The character used to separate thousands
	 *  in the whole part of the number.
	 *  Cannot be a digit and must be distinct from the
     *  <code>decimalSeparator</code>.
	 *
	 *  @default "."
     */
	public function get thousandsSeparator():String
	{
		return _thousandsSeparator;
	}
	public function set thousandsSeparator(value:String):void
	{
		thousandsSeparatorOverride = value;

		_thousandsSeparator = value != null ?
							  value :
							  resourceManager.getString(
							      "validators", "thousandsSeparator");
        validator = _validator;
	}

    /**
	 *  @private
	 *  Storage for the allowNegative property.
	 *  USED IN NUMBER VALIDATION
	 */
	private var _allowNegative:Boolean = true;
    [Inspectable(category="General")]
    /**
     *  Specifies whether negative numbers are permitted.
	 *  Valid values are <code>true</code> or <code>false</code>.
	 *
	 *  @default true
     */
	public function get allowNegative():Boolean
	{
		return _allowNegative;
	}
	public function set allowNegative(value:Boolean):void
	{
		_allowNegative = value;
        validator = _validator;
	}

    /**
	 *  @private
	 *  Storage for the decimalSeparator property.
	 *  USED IN NUMBER VALIDATION
	 */
	private var _decimalSeparator:String = ",";
	private var decimalSeparatorOverride:String;
    [Inspectable(category="General", defaultValue=",")]
    /**
     *  The character used to separate the whole
	 *  from the fractional part of the number.
	 *  Cannot be a digit and must be distinct from the
     *  <code>thousandsSeparator</code>.
	 *
	 *  @default "."
     */	
	public function get decimalSeparator():String
	{
		return _decimalSeparator;
	}
	public function set decimalSeparator(value:String):void
	{
		decimalSeparatorOverride = value;
		_decimalSeparator = value != null ?
							value :
							resourceManager.getString(
							    "validators", "decimalSeparator");
        validator = _validator;
	}

    /**
	 *  @private
	 *  Storage for the domain property.
	 *  USED IN NUMBER VALIDATION
	 */
	private var _domain:String;
	private var domainOverride:String;
    [Inspectable(category="General", enumeration="int,real", defaultValue="null")]
    /**
     *  Type of number to be validated.
	 *  Permitted values are <code>"real"</code> and <code>"int"</code>.
	 *
	 *  @default "real"
     */
	public function get domain():String
	{
		return _domain;
	}
	public function set domain(value:String):void
	{
		domainOverride = value;
		_domain = value != null ?
				  value :
				  resourceManager.getString(
				      "validators", "numberValidatorDomain");
        validator = _validator;
	}

    /**
	 *  @private
	 *  Storage for the precision property.
	 *  USED IN NUMBER VALIDATION
	 */
	private var _precision:Object;
	private var precisionOverride:Object;
    [Inspectable(category="General", defaultValue="null")]
    /**
     *  The maximum number of digits allowed to follow the decimal point.
	 *  Can be any nonnegative integer. 
	 *  Note: Setting to <code>0</code> has the same effect
	 *  as setting <code>domain</code> to <code>"int"</code>.
	 *  A value of -1 means it is ignored.
	 *
	 *  @default -1
     */
	public function get precision():Object
	{
		return _precision;
	}
	public function set precision(value:Object):void
	{
		precisionOverride = value;
		_precision = value != null ?
					 int(value) :
					 resourceManager.getInt(
					     "validators", "numberValidatorPrecision");
	}

    /**
	 *  @private
	 *  Add Clear Button
	 */
	private function addClearButton(event:FlexEvent):void{
		if(clearButton == null){
			clearButton = new Button();
			clearButton.width=10;
			clearButton.height=10;
			clearButton.y = (this.height - 10) / 2;
			clearButton.x = this.width - 10 - (this.height - 10) / 2;
			clearButton.focusEnabled=false;
			clearButton.setStyle("upSkin", CLEAR_BUTTON_ICON);
			clearButton.setStyle("overSkin", CLEAR_BUTTON_ICON);
			clearButton.setStyle("downSkin", CLEAR_BUTTON_ICON);
			clearButton.addEventListener(MouseEvent.CLICK, clearButton_clickHandler);
			clearButton.visible = false;
			clearButton.buttonMode = true;
			clearButton.useHandCursor = true;
			clearButton.mouseChildren = false;
			this.addChild(clearButton);
			showButton(null);
		}
	}
	private function clearButton_clickHandler(event:MouseEvent):void{
		//this.text = "";
		//clearButton.visible = false;
			if(isMasked){
				text = _inputMaskDefault;
				_text = _inputMaskDefault;
			}else{
				text = "";
			}
			
			oldMaskStr = _inputMaskDefault;
			clearButton.visible = false;
			dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function showButton(event:Event):void{
		if(clearButton){
			if(text != ""){
				clearButton.visible = true;
				this.setStyle("paddingRight",10);
			}else{
				clearButton.visible = false;
			}
		}
	}
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
		if(clearButton != null){
			clearButton.x = this.width - 10 - (this.height - 10) / 2;
			clearButton.y = (this.height - 10) / 2;
		}

        // Mask Implementation
		if(isMasked && (_text == _inputMaskDefault || text != "") ){
			text = _text;
		}
		
		checkPosition();

		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}


	/**
	 *  @public
	 *  Storage for the Show Clear Button property.
	 */
	private var _showClearButton:Boolean = true;
	[Inspectable(defaultValue="true",category="Boolean")]
	public function get showClearButton():Boolean
	{
		return _showClearButton;
	}
	public function set showClearButton(value:Boolean):void
	{
		this._showClearButton = value;
		
		if (value == false) 
		{
			clearButton = null;
		} 
		
		showButton(null);
	}

//////////////////////////////////////////////////////////////////////////
// INPUT MASK IMPLEMENTATION
/////////////////////////////////////////////////////////////////////////
	private var _inputMaskDefault:String = null; //__(__)___
	private var _inputMask:String = null; //##(##)9999
	private var _blankMaskChar:String = "_"; //_
	private var _actualText:String = null;
	private var _fullText:String = null;
	private var isMasked:Boolean = false;
	private var oldPosition:Number = -1;
	private var beginPosition:Number = -1;
	private var endPosition:Number = -1;
	private var currentKeyCode:Number = -1;
		
	// Temp variable for display
	private var _text:String = "";
	private var oldMaskStr:String = "";
		
	[Bindable]
	public function get inputMask():String{
		return _inputMask;
	}
	public function set inputMask(maskStr:String):void{
		
		_inputMask = maskStr;
		
		//Reset the text.
		text = "";
		if(_inputMask == "" || _inputMask == null){
			isMasked = false;
		}else{
			isMasked = true;
			
			_inputMaskDefault = _inputMask;
			for(var m:Number = 0; m < _inputMask.length; m++){
				if(validateCharAt(m)){
					_inputMaskDefault = _inputMaskDefault.substring(0, m) + _blankMaskChar + _inputMaskDefault.substring(m + 1);
				}
			}
		}
	}
		
	[Bindable]
	public function get actualText():String{
		_actualText = "";
		
		if(isMasked){
			
			for(var i:Number = 0; i < text.length; i++){
				if(validateCharAt(i) && text.charAt(i) != _blankMaskChar){
					_actualText += text.charAt(i);
				}
			}
			
		}else{
			_actualText = text;
		}
		return _actualText;
	}
	public function set actualText(actualTextStr:String):void{
		if(actualTextStr != null && actualTextStr != _text){
			if(isMasked && _inputMaskDefault != null){
				maskFocusInHandler(new FocusEvent(FocusEvent.FOCUS_IN));
				_actualText = _inputMaskDefault;
				_actualText = _actualText.substr(0, _inputMask.length);
				for(var m:Number = 0, n:Number = 0; m < _inputMaskDefault.length; m++){
					if(validateCharTypeAt(m, actualTextStr.charAt(n))){
						_actualText = _actualText.substring(0, m) + actualTextStr.charAt(n) + _actualText.substring(m + 1);
						n++;
					}
				}
				_text = _actualText;
				
				invalidateDisplayList();
				
				//Set the old text.
				oldMaskStr = _text;
			}else{
				text = actualTextStr;
			}
		}
	}
		
	[Bindable]
	public function get fullText():String{
		//full text = text
		_fullText = text;
		if(_fullText == "" && isMasked){
			_fullText = _inputMaskDefault;
		}
		
		return _fullText;
	}
	public function set fullText(fullTextStr:String):void{
		//Because set text is used in other methods and it's difficulty to differentiate paste and set text events,
		//fullText is used to set all the text to the TemplateInput.
		if(fullTextStr != null && fullTextStr != text){
			if(isMasked){
				maskFocusInHandler(new FocusEvent(FocusEvent.FOCUS_IN));
				_fullText = fullTextStr;
				_fullText = _fullText.substr(0, _inputMask.length);
				for(var i:Number = 0; i < _inputMask.length; i++){
					if(!validateCharTypeAt(i, _fullText.charAt(i))){
						_fullText = _fullText.substring(0, i) + _inputMaskDefault.charAt(i) + _fullText.substring(i + 1);
					}
				}
				_text = _fullText;
				
				invalidateDisplayList();
				//Set the old text.
				oldMaskStr = _text;
			}else{
				text = fullTextStr;
			}
		}
	}
		
	[Bindable]
	public function get blankMaskChar():String{
		return _blankMaskChar;
	}
	public function set blankMaskChar(blankMaskCharStr:String):void{
		
		if(blankMaskCharStr != null && blankMaskCharStr.length > 0){
			var tempChar:String = blankMaskCharStr.substring(0, 1);
			if(isMasked && _inputMaskDefault != null){
				for(var m:Number = 0; m < _inputMask.length; m++){
					if(validateCharAt(m)){
						//Replace the _inputDefault.
						_inputMaskDefault = _inputMaskDefault.substring(0, m) + tempChar + _inputMaskDefault.substring(m + 1);
						//Replace the current text.
						if(_text.charAt(m) == _blankMaskChar){
							_text = _text.substring(0, m) + tempChar + _text.substring(m + 1);
						}
					}
				}
				_blankMaskChar = tempChar;
				
				invalidateDisplayList();
				//Set the old text.
				oldMaskStr = _text;
			}else{
				_blankMaskChar = tempChar;
			}
		}
	}
				
	private function initMask(event:FlexEvent):void{
		if(isMasked && _blankMaskChar != null){
			_inputMaskDefault = _inputMask;
			for(var m:Number = 0; m < _inputMask.length; m++){
				if(validateCharAt(m)){
					_inputMaskDefault = _inputMaskDefault.substring(0, m) + _blankMaskChar + _inputMaskDefault.substring(m + 1);
				}
			}
		}
	}

	private function maskFocusInHandler(event:FocusEvent):void{
		
		if(text == "" || text == _inputMaskDefault){
			
			if(isMasked){
				_text = _inputMaskDefault;
				text = _inputMaskDefault;
				textField.text = _inputMaskDefault;
			}else{
				_text = "";
				textField.text = "";
			}
			
			oldMaskStr = textField.text;
			clearButton.visible = false;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
		
	private function maskFocusOutHandler(event:FocusEvent):void{
		
		if(text == "" || text == _inputMaskDefault){
		} else {
			notifyTextChange();
		}
	}
		
	private function maskTextChanged(event:Event):void{
		//close button
		if(text == "" || text == _inputMaskDefault){
			clearButton.visible = false;
		}else{
			clearButton.visible = true;
		}			
		if(isMasked){
			if(oldMaskStr != text){
				//Get the old text.
				_text = oldMaskStr;
				
				if(currentKeyCode == Keyboard.BACKSPACE && beginPosition == endPosition){
					//Process BACKSPACE.
					if(validateCharAt(selectionBeginIndex)){
						_text = _text.substring(0, selectionBeginIndex) + _blankMaskChar + _text.substring(selectionBeginIndex + 1);
					}
				}else if(text == ""){
					//For the check condition of updateDisplayList.
					_text = _inputMaskDefault;
				}else{
					var backStr:String = _text.substring(endPosition);
					var newStr:String = "";
					
					newStr = text.substring(beginPosition);
					
					if(newStr.length >= backStr.length){
						newStr = newStr.substr(0, newStr.length - backStr.length);
					}else{
						newStr = "";
					}
					//Get the new input text.
					newStr = newStr.substr(0, _inputMask.length);
					
					if(beginPosition == endPosition){
						endPosition++;
					}
					
					//End position of the new input text for check .
					var ep:Number = 0;
					//Set the end position.
					if(endPosition > beginPosition + newStr.length){
						ep = endPosition;
					}else{
						ep = beginPosition + newStr.length;
					}
					//Because we check the position first, the position is suitable for a single char.
					if(newStr.length == 1){
						if(validateCharTypeAt(beginPosition, newStr.charAt(0))){
							_text = _text.substring(0, beginPosition) + newStr.charAt(0) + _text.substring(beginPosition + 1);
						}else{
							setSelection(oldPosition, oldPosition);
							if(newStr && newStr.length > 0){
								//showErrorTip(errorTipText.replace(/@/g, newStr.substr(0, 1)));
							}
						}
					//}else if(newStr.length > 1 || Keyboard.DELETE){
					}else{
						//multiple chars
						var isReplaced:Boolean = false;
						for(var m:Number = beginPosition, n:Number = 0; m < ep; m++){
							//Is template position and within newStr, replace new char.
							if(validateCharAt(m) && n < newStr.length){
								if(validateCharTypeAt(m, newStr.charAt(n))){
									_text = _text.substring(0, m) + newStr.charAt(n) + _text.substring(m + 1);
									isReplaced = true;
								}
							//Is template position but without the newStr, replace blank char.
							}else if(validateCharAt(m)){
								_text = _text.substring(0, m) + _blankMaskChar + _text.substring(m + 1);
							//Not template position, keep char of template.
							}else if(!validateCharAt(m)){
								_text = _text.substring(0, m) + _inputMask.charAt(m) + _text.substring(m + 1);
							}
							n++;
						}
						if(_text == oldMaskStr && !isReplaced){
							if(newStr && newStr.length > 0){
								//showErrorTip(errorTipText.replace(/@/g, newStr.substr(0, 1)));
							}
						}
					}
				}
				
				invalidateDisplayList();
				
				//set the old text
				oldMaskStr = _text;
					
			}
			
			//set the old position
			beginPosition = selectionBeginIndex;
			endPosition = selectionEndIndex;
			oldPosition = selectionBeginIndex;
		}
		//Make the actualText change to notify others the property has benn changed (use for data binding).
		notifyTextChange();
		
	}

	private function maskSetPosition(event:Event):void{
		if(isMasked){
			
			beginPosition = selectionBeginIndex;
			endPosition = selectionEndIndex;
				
			if(event is KeyboardEvent){
				currentKeyCode = KeyboardEvent(event).keyCode;
			}
			
			if(event.type != MouseEvent.MOUSE_MOVE && currentKeyCode != Keyboard.BACKSPACE){
				invalidateDisplayList();
			}
		}
	}
		
	private function checkPosition():void{
		if(isMasked){
			
			if(currentKeyCode == Keyboard.BACKSPACE){
				
				if(!validateCharAt(selectionBeginIndex) && oldPosition >= 0 && selectionBeginIndex <= _inputMask.length && selectionBeginIndex >=0){
					//BackSpace: Del the jumped char.
					var t:String = _inputMaskDefault.substr(0, selectionBeginIndex);
					var ep:Number = t.lastIndexOf(_blankMaskChar);
					
					if(ep >= 0){
						for(var j:Number = ep; j < oldPosition; j++){
							if(validateCharAt(j)){
								_text = oldMaskStr.substr(0, j) + _blankMaskChar + oldMaskStr.substr(j + 1);
							}
						}
						
						oldPosition = ep;
						setSelection(ep, ep);
						callLater(invalidateDisplayList);
					}else{
						ep = _inputMaskDefault.indexOf(_blankMaskChar);
						oldPosition = ep;
						setSelection(ep, ep);
					}
					
					oldMaskStr = _text;
				}else{
					oldPosition = selectionBeginIndex;
				}
				
				
			}else if(!validateCharAt(selectionBeginIndex) && oldPosition >= 0 && selectionBeginIndex <= _inputMask.length && selectionBeginIndex >=0){
				
				if(selectionBeginIndex >= oldPosition){
					//To find the latest "#" position, and move to it.
					var t1:String = _inputMaskDefault.substring(selectionBeginIndex);
					var p1:Number = t1.indexOf(_blankMaskChar);
					if(p1 >= 0){
						oldPosition = selectionBeginIndex + p1;
						setSelection(selectionBeginIndex + p1, selectionBeginIndex + p1);
					}else{
						p1 = _inputMaskDefault.lastIndexOf(_blankMaskChar);
						oldPosition = p1;
						setSelection(p1, p1);
					}
				}else{
					//To find the latest "#" position, and move to it.
					var t2:String = _inputMaskDefault.substr(0, selectionBeginIndex);
					var p2:Number = t2.lastIndexOf(_blankMaskChar);
					
					if(p2 >= 0){
						
						oldPosition = p2;
						setSelection(p2, p2);
					}else{
						p2 = _inputMaskDefault.indexOf(_blankMaskChar);
						oldPosition = p2;
						setSelection(p2, p2);
					}
					
				}
			}else{
				oldPosition = selectionBeginIndex;
			}
		}
	}
		
		
	private function notifyTextChange():void{
		actualText = null;
		actualText = _text;
		fullText = null;
		fullText = text;
	}
	
	protected function validateCharAt(index:Number):Boolean{
		var templateChar:String = _inputMask.charAt(index);
		return validateChar(templateChar);
	}
	
	protected function validateCharTypeAt(index:Number, inputChar:String):Boolean{
		var templateChar:String = _inputMask.charAt(index);
		return validateCharType(templateChar, inputChar);
	}
				
	/**
	 * @param templateChar The template char
	 * @return The validate result
	 */
	public function validateChar(maskChar:String):Boolean{
		switch(maskChar){
			case "#":
				return true;
			case "@":
				return true;
			case "9":
				return true;
			default:
				return false;
		}
	}
		
	/**
	 * @param templateChar The template char
	 * @param inputChar The input char
	 * @return The validate result
	 */
	public function validateCharType(maskChar:String, inputMaskChar:String):Boolean{
		var pattern:RegExp = /""/;
		switch(maskChar){
			case "#":
				pattern = /[^0-9]/
				break;
			case "@":
				pattern = /[^`]/
				break;
			case "9":
				pattern = /\d/
				break;
			default:
				pattern = /""/;
				break;
		}
		return pattern.test(inputMaskChar);
	}
	


}
}