import { Get, Body, Controller, Post, HttpCode, HttpStatus, UnauthorizedException } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { SignInDto } from "./DTO/signIn.dto";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { AuthUser, Public } from "./auth.decorator";
import { User } from "src/entities/user.entity";
import { Researcher } from "src/entities/researcher.entity";
import { ResetPasswordDto } from "./DTO/resetPassword.dto";
import { ResetPasswordUserDto } from "./DTO/resetPasswordUser.dto";
import { UserType } from "src/entities/user_type.enum";
import { Roles } from "./roles.decorator";
import { UserService } from "src/User/user.service";
import { ResearcherService } from "src/Researcher/researcher.service";
@ApiTags("Auth")
@Controller("auth")
export class AuthController {
  constructor(
    private authService: AuthService,
    private userService: UserService,
    private researcherService: ResearcherService
    
  ) {}

  @HttpCode(HttpStatus.OK)
  @Public()
  @Post("login/user")
  signInUser(@Body() signInDto: SignInDto) {
    return this.authService.signInUser(signInDto.username, signInDto.password);
  }

  @HttpCode(HttpStatus.OK)
  @ApiSecurity("bearer")
  @Post("register/user")
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  signUpUser(@Body() signUpDto: User, @AuthUser() user: any) {
    if(user.type === UserType.RESEARCHER){
      if(signUpDto.organization === undefined){
        signUpDto.organization = user.organization;
      }else{
        if(signUpDto.organization !== user.organization){
          throw new UnauthorizedException();
        }
      }
    }

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
  @Post("login/admin")
  signInAdmin(@Body() signInDto: SignInDto) {
    return this.authService.signInAdmin(
      signInDto.username,
      signInDto.password
    );
  }

  @HttpCode(HttpStatus.OK)
  @ApiSecurity("bearer")
  @Post("register/researcher")
  @Roles(UserType.ADMIN)
  signUp(@Body() signUpDto: Researcher) {
    return this.authService.signUpResearcher(signUpDto);
  }

  @ApiSecurity("bearer")
  @HttpCode(HttpStatus.OK)
  @Post("reset-password/user")
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async resetPasswordUser(@Body() resetDto: ResetPasswordUserDto, @AuthUser() user: any) {
    if(user.type === UserType.RESEARCHER){
      let targetUser = await this.userService.findOne({
        where: {
          username: resetDto.username
        }
      });
      
      if(targetUser === undefined){
        throw new UnauthorizedException();
      }

      if(targetUser.organization !== user.organization){
        throw new UnauthorizedException();
      }
      
    }

    return this.authService.resetPasswordUser(resetDto);
  }

  @ApiSecurity("bearer")
  @HttpCode(HttpStatus.OK)
  @Post("reset-password/researcher")
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async resetPasswordResearcher(@Body() resetDto: ResetPasswordDto, @AuthUser() user: any) {
    if(user.type === UserType.RESEARCHER){
      let targetUser = await this.researcherService.findOne({
        where: {
          username: resetDto.username
        }
      });
      
      if(targetUser === undefined){
        throw new UnauthorizedException();
      }

      if(targetUser.id !== user.id){
        throw new UnauthorizedException();
      }
      
    }

    return this.authService.resetPasswordResearcher(resetDto);
  }

  @ApiSecurity("bearer")
  @HttpCode(HttpStatus.OK)
  @Post("reset-password/admin")
  @Roles(UserType.ADMIN)
  resetPasswordAdmin(@Body() resetDto: ResetPasswordDto) {
    return this.authService.resetPasswordAdmin(resetDto);
  }

  @ApiSecurity("bearer")
  @HttpCode(HttpStatus.OK)
  @Get("check-jwt")
  checkJwt(){
    return "ok";
  }
}
