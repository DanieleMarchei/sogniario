import { Get, Body, Controller, Post, HttpCode, HttpStatus, UnauthorizedException, UseGuards } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateOTPDto } from "./DTO/createOTP.dto";
import { OTPService } from "./otp.service";
import { OTPGuard } from "./otp.guard";
import { CheckOTPDto } from "./DTO/checkOTP.dto";
import { UserService } from "src/User/user.service";
import { MailService } from "src/mail/mail.service";
import { Public } from "src/Auth/auth.decorator";
import { User } from "src/entities/user.entity";
import { OrganizationService } from "src/Organization/organization.service";
import { env } from "process";
import { Throttle } from "@nestjs/throttler";

@ApiTags("OTP")
@Controller("otp")
export class OTPController {
  constructor(
    private otpService: OTPService,
    private userService: UserService,
    private organizationService: OrganizationService,
    private mailService: MailService,

  ) { }

  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 3, ttl: 60000 } })
  @Public()
  @UseGuards(OTPGuard)
  @Post("sign_up")
  async signUpUser(@Body() createOTPDto: CreateOTPDto) {
    const cr = require("crypto");
    const hmac = cr.createHmac('sha512', process.env.EMAIL_SALT);
    hmac.update(createOTPDto.email);
    var hemail = hmac.digest("hex");

    var user = await this.userService.findOne({ where: { email: hemail } });

    if (user !== null) {
      // we give the user a random id to make it undistinguishable 
      // with the case when the email was not already registered
      // if we returned a different value, one can check if a certain mail
      // is registered in the database, which can be a possible privacy violation

      // we also execute the same function to reduce the possibility of a timing attack
      // but we do not insert the otp in the database
      var [uuid, otp] = await this.otpService.createOTP(createOTPDto, false);
      return uuid;
    }



    var [uuid, otp] = await this.otpService.createOTP(createOTPDto);

    this.mailService.sendEmail({
      email: createOTPDto.email,
      subject: "Verifica l'iscrizione a Sogniario",
      template: 'code-email',
      context: {
        code: otp
      },
    });

    return uuid;
  }

  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 2, ttl: 60000 } })
  @Public()
  @Post("check_otp")
  async checkOtp(@Body() checkOTPDto: CheckOTPDto): Promise<boolean> {
    var [is_valid, hashed_email, hashed_password] = await this.otpService.checkOTP(checkOTPDto);
    if (is_valid && hashed_email !== null && hashed_password !== null) {
      var organization = await this.organizationService.findOne({
        where: { name: process.env.SIGNUP_USERS_ORGANIZATION_NAME }
      });
      do {
        var username = this.randomString(8);

        var newUser = new User();
        newUser.username = username;
        newUser.email = hashed_email;
        newUser.password = hashed_password;
        newUser.organization = organization;
        var inserted = true;
        try {
          await this.userService.insertUser(newUser);

        } catch (error) {
          inserted = false;
        }

      } while (!inserted);



      await this.mailService.sendEmail({
        email: checkOTPDto.email,
        subject: "Benvenuto/a in Sogniario!",
        template: 'sogniario-welcome',
        context: {
          username: username
        },
      });

    }
    return is_valid;
  }

  randomString(length): string {
    // return "asdasd12";
    const cr = require("crypto");
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;

    for (var i = 0; i < length; i++) {
      var idx = cr.randomInt(charactersLength);
      result += characters.charAt(idx);
    }
    return result;
  }

}

