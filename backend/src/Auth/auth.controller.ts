import { Body, Controller, Post, HttpCode, HttpStatus } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { SignInDto } from "./DTO/signIn.dto";
import { ApiTags } from "@nestjs/swagger";
import { Public } from "./auth.decorator";
import { User } from "src/entities/user.entity";
import { Researcher } from "src/entities/researcher.entity";
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
}
