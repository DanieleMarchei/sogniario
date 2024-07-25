import { Get, Body, Controller, Post, HttpCode, HttpStatus } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { SignInDto } from "./DTO/signIn.dto";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Public } from "./auth.decorator";
import { User } from "src/entities/user.entity";
import { Researcher } from "src/entities/researcher.entity";
import { ResetPasswordDto } from "./DTO/resetPassword.dto";
import { ResetPasswordUserDto } from "./DTO/resetPasswordUser.dto";
@ApiTags("Auth")
@Controller("auth")
export class AuthController {
  constructor(private authService: AuthService) {}

  @HttpCode(HttpStatus.OK)
  @Public()
  @Post("login/user")
  signInUser(@Body() signInDto: SignInDto) {
    return this.authService.signInUser(signInDto.username, signInDto.password);
  }

  @HttpCode(HttpStatus.OK)
  @Public()
  @Post("register/user")
  signUpUser(@Body() signUpDto: User) {
    return this.authService.signUpUser(signUpDto);
  }

  @HttpCode(HttpStatus.OK)
  @Public()
  @Post("login/researcher")
  signInResearcher(@Body() signInDto: SignInDto) {
    return this.authService.signInResearcher(
      signInDto.username,
      signInDto.password
    );
  }

  @HttpCode(HttpStatus.OK)
  @Public()
  @Post("register/researcher")
  signUp(@Body() signUpDto: Researcher) {
    return this.authService.signUpResearcher(signUpDto);
  }
  @ApiSecurity("bearer")
  @HttpCode(HttpStatus.OK)
  @Post("reset-password/user")
  resetPasswordUser(@Body() resetDto: ResetPasswordUserDto) {
    return this.authService.resetPasswordUser(resetDto);
  }

  @ApiSecurity("bearer")
  @HttpCode(HttpStatus.OK)
  @Post("reset-password/researcher")
  resetPasswordResearcher(@Body() resetDto: ResetPasswordDto) {
    return this.authService.resetPasswordResearcher(resetDto);
  }

  @ApiSecurity("bearer")
  @HttpCode(HttpStatus.OK)
  @Get("check-jwt")
  checkJwt(){
    return "ok";
  }
}
