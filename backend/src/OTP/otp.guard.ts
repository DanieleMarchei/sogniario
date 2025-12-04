import {
	CanActivate,
	ExecutionContext,
	Injectable,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { UserService } from "src/User/user.service";

@Injectable()
export class OTPGuard implements CanActivate {
	constructor(
		private userService: UserService
	) {}

	async canActivate(context: ExecutionContext): Promise<boolean> {

    const request = context.switchToHttp().getRequest();
		const createOTPdto = request.body;

		if (createOTPdto.email != createOTPdto.confirm_email){
			return false;
		}

		if (createOTPdto.password != createOTPdto.confirm_password){
			return false;
		}

		if (!EmailValidator.validate(createOTPdto.email, false, false)){
			return false;
		}



		return true;
	}


}

/////// A TS port of Dart's email_validator package


/// The Type enum
///
/// The domain type is either None, Alphabetic, Numeric or AlphaNumeric
enum SubdomainType { None, Alphabetic, Numeric, AlphaNumeric }

///The EmailValidator entry point
///
/// To use the EmailValidator class, call EmailValidator.methodName
class EmailValidator {
  static _index : number = 0;

  static _atomCharacters : string = "!#\$%&'*+-/=?^_`{|}~";
  static _domainType : SubdomainType = SubdomainType.None;

  static _isDigit(c : string) : boolean {
    return c.charCodeAt(0) >= 48 && c.charCodeAt(0) <= 57;
  }

  static _isLetter(c : string) : boolean {
    return (c.charCodeAt(0) >= 65 && c.charCodeAt(0) <= 90) ||
        (c.charCodeAt(0) >= 97 && c.charCodeAt(0) <= 122);
  }

  static _isLetterOrDigit(c : string) : boolean {
    return this._isLetter(c) || this._isDigit(c);
  }

  static _isAtom(c : string, allowInternational : boolean) : boolean {
    return c.charCodeAt(0) < 128
        ? this._isLetterOrDigit(c) || this._atomCharacters.includes(c)
        : allowInternational;
  }

  // First checks whether the first letter in string c is a letter, number or special
  // character
  // If calling isLetter returns true or c is '-',
  // domainType is set to Alphabetic and the function returns true
  // If calling isDigit returns true
  // domainType is set to Numeric and the function returns true
  // Otherwise the function returns false
  //
  // If the first if statement for string c being a letter, number or special character
  // fails
  // The value of allowInternational is checked where, if true,
  // domainType is set to Alphabetic and the function returns true
  // Otherwise, the function returns false
  static _isDomain(c : string, allowInternational : boolean) : boolean {
    if (c.charCodeAt(0) < 128) {
      if (this._isLetter(c) || c == '-') {
        this._domainType = SubdomainType.Alphabetic;
        return true;
      }

      if (this._isDigit(c)) {
        this._domainType = SubdomainType.Numeric;
        return true;
      }

      return false;
    }

    if (allowInternational) {
      this._domainType = SubdomainType.Alphabetic;
      return true;
    }

    return false;
  }

  // Returns true if domainType is not None
  // Otherwise returns false
  static _isDomainStart(c : string, allowInternational : boolean) : boolean {
    if (c.charCodeAt(0) < 128) {
      if (this._isLetter(c)) {
        this._domainType = SubdomainType.Alphabetic;
        return true;
      }

      if (this._isDigit(c)) {
        this._domainType = SubdomainType.Numeric;
        return true;
      }

      this._domainType = SubdomainType.None;

      return false;
    }

    if (allowInternational) {
      this._domainType = SubdomainType.Alphabetic;
      return true;
    }

    this._domainType = SubdomainType.None;

    return false;
  }

  static _skipAtom(text : string, allowInternational : boolean) : boolean {
    var startIndex = this._index;

    while (this._index < text.length && this._isAtom(text[this._index], allowInternational)) {
      this._index++;
    }

    return this._index > startIndex;
  }

  // Skips checking of subdomain and returns false if domainType is None
  // Otherwise returns true
  static _skipSubDomain(text : string, allowInternational : boolean) {
    var startIndex = this._index;

    if (!this._isDomainStart(text[this._index], allowInternational)) {
      return false;
    }

    this._index++;

    while (
        this._index < text.length && this._isDomain(text[this._index], allowInternational)) {
      this._index++;
    }

    // 1 letter tld is not valid
    if (this._index == text.length && (this._index - startIndex) == 1) {
      return false;
    }

    return (this._index - startIndex) < 64 && text[this._index - 1] != '-';
  }

  // Skips checking of domain if domainType is numeric and returns false
  // Otherwise, return true
  static _skipDomain(text : string, allowTopLevelDomains : boolean, allowInternational : boolean) : boolean {
    if (!this._skipSubDomain(text, allowInternational)) {
      return false;
    }

    if (this._index < text.length && text[this._index] == '.') {
      do {
        this._index++;

        if (this._index == text.length) {
          return false;
        }

        if (!this._skipSubDomain(text, allowInternational)) {
          return false;
        }
      } while (this._index < text.length && text[this._index] == '.');
    } else if (!allowTopLevelDomains) {
      return false;
    }

    // Note: by allowing AlphaNumeric,
    // we get away with not having to support punycode.
    if (this._domainType == SubdomainType.Numeric) {
      return false;
    }

    return true;
  }

  // Function skips over quoted text where if quoted text is in the string
  // the function returns true
  // otherwise the function returns false
  static _skipQuoted(text : string, allowInternational : boolean) : boolean {
    var escaped = false;

    // skip over leading '"'
    this._index++;

    while (this._index < text.length) {
      if (text[this._index].charCodeAt(0) >= 128 && !allowInternational) {
        return false;
      }

      if (text[this._index] == '\\') {
        escaped = !escaped;
      } else if (!escaped) {
        if (text[this._index] == '"') {
          break;
        }
      } else {
        escaped = false;
      }

      this._index++;
    }

    if (this._index >= text.length || text[this._index] != '"') {
      return false;
    }

    this._index++;

    return true;
  }

  // TODO: Documentation for this function is required
  static _skipIPv4Literal(text : string) : boolean {
    var groups = 0;

    while (this._index < text.length && groups < 4) {
      var startIndex = this._index;
      var value = 0;

      while (this._index < text.length &&
          text[this._index].charCodeAt(0) >= 48 &&
          text[this._index].charCodeAt(0) <= 57) {
        value = (value * 10) + (text[this._index].charCodeAt(0) - 48);
        this._index++;
      }

      if (this._index == startIndex || this._index - startIndex > 3 || value > 255) {
        return false;
      }

      groups++;

      if (groups < 4 && this._index < text.length && text[this._index] == '.') {
        this._index++;
      }
    }

    return groups == 4;
  }

  static _isHexDigit(str : string) : boolean {
    var c = str.charCodeAt(0);
    return (c >= 65 && c <= 70) ||
        (c >= 97 && c <= 102) ||
        (c >= 48 && c <= 57);
  }

  // This needs to handle the following forms:
  //
  // IPv6-addr = IPv6-full / IPv6-comp / IPv6v4-full / IPv6v4-comp
  // IPv6-hex  = 1*4HEXDIG
  // IPv6-full = IPv6-hex 7(":" IPv6-hex)
  // IPv6-comp = [IPv6-hex *5(":" IPv6-hex)] "::" [IPv6-hex *5(":" IPv6-hex)]
  //             ; The "::" represents at least 2 16-bit groups of zeros
  //             ; No more than 6 groups in addition to the "::" may be
  //             ; present
  // IPv6v4-full = IPv6-hex 5(":" IPv6-hex) ":" IPv4-address-literal
  // IPv6v4-comp = [IPv6-hex *3(":" IPv6-hex)] "::"
  //               [IPv6-hex *3(":" IPv6-hex) ":"] IPv4-address-literal
  //             ; The "::" represents at least 2 16-bit groups of zeros
  //             ; No more than 4 groups in addition to the "::" and
  //             ; IPv4-address-literal may be present
  static _skipIPv6Literal(text : string) : boolean {
    var compact = false;
    var colons = 0;

    while (this._index < text.length) {
      var startIndex = this._index;

      while (this._index < text.length && this._isHexDigit(text[this._index])) {
        this._index++;
      }

      if (this._index >= text.length) {
        break;
      }

      if (this._index > startIndex && colons > 2 && text[this._index] == '.') {
        // IPv6v4
        this._index = startIndex;

        if (!this._skipIPv4Literal(text)) {
          return false;
        }

        return compact ? colons < 6 : colons == 6;
      }

      var count = this._index - startIndex;
      if (count > 4) {
        return false;
      }

      if (text[this._index] != ':') {
        break;
      }

      startIndex = this._index;
      while (this._index < text.length && text[this._index] == ':') {
        this._index++;
      }

      count = this._index - startIndex;
      if (count > 2) {
        return false;
      }

      if (count == 2) {
        if (compact) {
          return false;
        }

        compact = true;
        colons += 2;
      } else {
        colons++;
      }
    }

    if (colons < 2) {
      return false;
    }

    return compact ? colons < 7 : colons == 7;
  }

  /// Validate the specified email address.
  ///
  /// If [allowTopLevelDomains] is `true`, then the validator will
  /// allow addresses with top-level domains like `email@example`.
  ///
  /// If [allowInternational] is `true`, then the validator
  /// will use the newer International Email standards for validating
  /// the email address.
  static validate(email : string, allowTopLevelDomains = false, allowInternational = true) : boolean {
    this._index = 0;

    if (email.length == 0 || email.length >= 255) {
      return false;
    }

    // Local-part = Dot-string / Quoted-string
    //       ; MAY be case-sensitive
    //
    // Dot-string = Atom *("." Atom)
    //
    // Quoted-string = DQUOTE *qcontent DQUOTE
    if (email[this._index] == '"') {
      if (!this._skipQuoted(email, allowInternational) || this._index >= email.length) {
        return false;
      }
    } else {
      if (!this._skipAtom(email, allowInternational) || this._index >= email.length) {
        return false;
      }

      while (email[this._index] == '.') {
        this._index++;

        if (this._index >= email.length) {
          return false;
        }

        if (!this._skipAtom(email, allowInternational)) {
          return false;
        }

        if (this._index >= email.length) {
          return false;
        }
      }
    }

    if (this._index + 1 >= email.length || this._index > 64 || email[this._index++] != '@') {
      return false;
    }

    if (email[this._index] != '[') {
      // domain
      if (!this._skipDomain(email, allowTopLevelDomains, allowInternational)) {
        return false;
      }

      return this._index == email.length;
    }

    // address literal
    this._index++;

    // we need at least 8 more characters
    if (this._index + 8 >= email.length) {
      return false;
    }

    var ipv6 = email.substring(this._index - 1).toLowerCase();

    if (ipv6.includes('ipv6:')) {
      this._index += 'IPv6:'.length;
      if (!this._skipIPv6Literal(email)) {
        return false;
      }
    } else {
      if (!this._skipIPv4Literal(email)) {
        return false;
      }
    }

    if (this._index >= email.length || email[this._index++] != ']') {
      return false;
    }

    return this._index == email.length;
  }
}
