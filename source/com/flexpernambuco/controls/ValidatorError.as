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

package com.flexpernambuco.controls
{
	import mx.collections.ArrayCollection;
	
	public final class ValidatorError
	{

		public static const EMAIL_INVALID_CHAR_ERROR:ArrayCollection = 
			new ArrayCollection(["Seu endereço de e-mail contém caracteres inválidos.",
							"Your e-mail address contains invalid characters.",
							""]);
		public static const EMAIL_INVALID_DOMAIN_ERROR:ArrayCollection = 
			new ArrayCollection(["O domínio em seu e-mail está formatado incorretamente.",
							"The domain in your e-mail address is incorrectly formatted.",
							""]);
		public static const EMAIL_INVALID_IP_DOMAIN_ERROR:ArrayCollection = 
			new ArrayCollection(["Seu endereço de e-mail contém caracteres inválidos.",
							"The IP domain in your e-mail address is incorrectly formatted.",
							""]);
		public static const EMAIL_INVALID_PERIODS_IN_DOMAIN_ERROR:ArrayCollection = 
			new ArrayCollection(["O domínio em seu endereço de e-mail tem períodos consecutivos." ,
							"The domain in your e-mail address has consecutive periods.",
							""]);
		public static const EMAIL_MISSING_AT_SIGN_ERROR:ArrayCollection = 
			new ArrayCollection(["Está faltando um sinal (@) no seu endereço de e-mail." ,
							"An at sign (@) is missing in your e-mail address.",
							""]);
		public static const EMAIL_MISSING_PERIOD_IN_DOMAIN_ERROR:ArrayCollection = 
			new ArrayCollection(["O domínio em seu e-mail está faltando um período.",
							"The domain in your e-mail address is missing a period.",
							""]);
		public static const EMAIL_MISSING_USERNAME_ERROR:ArrayCollection = 
			new ArrayCollection(["O nome de usuário em seu e-mail está faltando." ,
							"The username in your e-mail address is missing.",
							""]);
		public static const EMAIL_TOO_MANY_AT_SIGNS_ERROR:ArrayCollection = 
			new ArrayCollection(["Seu endereço de e-mail contém demasiadas @ caracteres.",
							"Your e-mail address contains too many @ characters.",
							""]);
		public static const EMAIL_REQUIRED_FIELD_ERROR:ArrayCollection = 
			new ArrayCollection(["Este campo é obrigatório.",
							"This field is required.",
							""]);

		// PHONE NUMBER
		public static const PHONE_INVALID_CHAR_ERROR:ArrayCollection = 
			new ArrayCollection(["Seu número de telefone contém caracteres inválidos." ,
							"Your telephone number contains invalid characters.",
							""]);
		public static const PHONE_WRONG_LENGTH_ERROR:ArrayCollection = 
			new ArrayCollection(["Seu número de telefone deve conter, no mínimo, 10 dígitos.",
							"Your telephone number must contain at least 10 digits.",
							""]);
		public static const PHONE_REQUIRED_FIELD_ERROR:ArrayCollection = 
			new ArrayCollection(["Este campo é obrigatório.",
							"This field is required.",
							""]);

		// DATE
		public static const DATE_WRONG_DAY_ERROR:ArrayCollection = 
			new ArrayCollection(["Introduzir um dia válido para o mês."  ,
							"Enter a valid day for the month.",
							""]);
		public static const DATE_WRONG_LENGTH_ERROR:ArrayCollection = 
			new ArrayCollection(["Digite a data no formato : " ,
							"Type the date in the format : " ,
							""]);
		public static const DATE_WRONG_MONTH_ERROR:ArrayCollection = 
			new ArrayCollection(["Introduza um mês entre 1 e 12.",
							"Enter a month between 1 and 12.",
							""]);
		public static const DATE_WRONG_YEAR_ERROR:ArrayCollection = 
			new ArrayCollection(["Digite um ano entre 0 e 9999.",
							"Enter a year between 0 and 9999.",
							""]);
		public static const DATE_INVALID_CHAR_ERROR:ArrayCollection = 
			new ArrayCollection(["A data contém caracteres inválidos.",
							"The date contains invalid characters.",
							""]);
		public static const DATE_FORMAT_ERROR:ArrayCollection = 
			new ArrayCollection(["Erro de configuração: Incorreta string de formatação.",
							"Configuration error: Incorrect formatting string.",
							""]);
		public static const DATE_REQUIRED_FIELD_ERROR:ArrayCollection = 
			new ArrayCollection(["Este campo é obrigatório.",
							"This field is required.",
							""]);

		// STRING
		public static const STRING_TOO_LONG_ERROR:ArrayCollection = 
			new ArrayCollection(["Esta seqüência é mais longa do que o tamanho máximo permitido. Este deve ser inferior a "  ,
							"This string is longer than the maximum allowed length. This must be less than ",
							""]);
		public static const STRING_TOO_LONG_ERROR_CHAR:ArrayCollection = 
			new ArrayCollection([" caracteres." ,
							" characters long.",
							""]);
		public static const STRING_TOO_SHORT_ERROR:ArrayCollection = 
			new ArrayCollection(["Esta sequência é mais curta do que o comprimento mínimo permitido. Este deve ser pelo menos "  ,
							"This string is shorter than the minimum allowed length. This must be at least ",
							""]);
		public static const STRING_TOO_SHORT_ERROR_CHAR:ArrayCollection = 
			new ArrayCollection([" caracteres." ,
							" characters long.",
							""]);
		public static const STRING_REQUIRED_FIELD_ERROR:ArrayCollection = 
			new ArrayCollection(["Este campo é obrigatório.",
							"This field is required.",
							""]);

		// NUMBER
		public static const NUMBER_DECIMAL_POINT_COUNT_ERROR:ArrayCollection = 
			new ArrayCollection(["O separador decimal só pode ocorrer uma vez.",
							"The decimal separator can only occur once.",
							""]);
		public static const NUMBER_EXCEEDS_MAX_ERROR:ArrayCollection = 
			new ArrayCollection(["O número informado é muito grande." ,
							"The number entered is too large.",
							""]);
		public static const NUMBER_INTEGER_ERROR:ArrayCollection = 
			new ArrayCollection(["O número deve ser um número inteiro." ,
							"The number must be an integer.",
							""]);
		public static const NUMBER_INVALID_CHAR_ERROR:ArrayCollection = 
			new ArrayCollection(["A entrada contém caracteres inválidos." ,
							"The input contains invalid characters." ,
							""]);
		public static const NUMBER_INVALID_FORMAT_CHARS_ERROR:ArrayCollection = 
			new ArrayCollection(["Um dos parâmetros de formatação é inválido.",
							"One of the formatting parameters is invalid.",
							""]);
		public static const NUMBER_LOWER_THAN_MIN_ERROR:ArrayCollection = 
			new ArrayCollection(["O valor informado é muito pequeno."  ,
							"The amount entered is too small.",
							""]);
		public static const NUMBER_NEGATIVE_ERROR:ArrayCollection = 
			new ArrayCollection(["O valor não pode ser negativo." ,
							"The amount may not be negative." ,
							""]);
		public static const NUMBER_PRECISION_ERROR:ArrayCollection = 
			new ArrayCollection(["O valor informado possui muitos dígitos depois da vírgula.",
							"The amount entered has too many digits beyond the decimal point.",
							""]);
		public static const NUMBER_SEPARATION_ERROR:ArrayCollection = 
			new ArrayCollection(["O separador de milhar deve ser seguido por três dígitos.",
							"The thousands separator must be followed by three digits.",
							""]);
		public static const NUMBER_REQUIRED_FIELD_ERROR:ArrayCollection = 
			new ArrayCollection(["Este campo é obrigatório.",
							"This field is required.",
							""]);

		
		

			}
}