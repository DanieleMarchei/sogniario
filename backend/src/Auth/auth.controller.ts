import { Body, Controller, Post, HttpCode, HttpStatus } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { SignInDto } from "./DTO/signIn.dto";
import { ApiTags } from "@nestjs/swagger";
import { Public } from "./auth.decorator";
import { User } from "src/entities/user.entity";
@ApiTags("Auth")
@Controller("auth")
export class AuthController {
  constructor(private authService: AuthService) {}
  @HttpCode(HttpStatus.OK)
  @Public()
  @Post("login")
  signIn(@Body() signInDto: SignInDto) {
    return this.authService.signIn(signInDto.username, signInDto.password);
  }

  @HttpCode(HttpStatus.OK)
  @Public()
  @Post("register")
  signUp(@Body() signUpDto: User) {
    return this.authService.signUp(signUpDto);
  }
}
