import {
  HttpException,
  HttpStatus,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { UserService } from "src/User/user.service";
import { JwtService } from "@nestjs/jwt";
import { User } from "src/entities/user.entity";
import { ResearcherService } from "src/Researcher/researcher.service";
import { Researcher } from "src/entities/researcher.entity";
import { ResetPasswordDto } from "./DTO/resetPassword.dto";
import { ResetPasswordUserDto } from "./DTO/resetPasswordUser.dto";
import { AdminService } from "src/Admin/admin.service";

@Injectable()
export class AuthService {
  constructor(
    private usersService: UserService,
    private researcerService: ResearcherService,
    private adminService: AdminService,
    private jwtService: JwtService
  ) {}


  async resetPasswordUser(resetPassword : ResetPasswordUserDto){
    const bcrypt = require("bcrypt");

    const user = await this.usersService.findOne({
      where: { username: resetPassword.username, deleted: false },
    });

    if (!user) {
      throw new UnauthorizedException();
    }

    let newPassword = await bcrypt.hash(resetPassword.new_password, 10);

    user.password = newPassword;
    return this.usersService.saveUser(user);

  }

  async resetPasswordResearcher(resetPassword : ResetPasswordDto){
    const bcrypt = require("bcrypt");

    const researcher = await this.researcerService.findOne({
      where: { username: resetPassword.username, deleted: false },
    });

    if (!researcher || !(await bcrypt.compare(resetPassword.old_password, researcher.password))) {
      throw new UnauthorizedException();
    }

    let newPassword = await bcrypt.hash(resetPassword.new_password, 10);

    researcher.password = newPassword;
    return this.researcerService.saveResearcher(researcher);

  }

  async resetPasswordAdmin(resetPassword : ResetPasswordDto){
    const bcrypt = require("bcrypt");

    const admin = await this.adminService.findOne({
      where: { username: resetPassword.username, deleted: false },
    });

    if (!admin || !(await bcrypt.compare(resetPassword.old_password, admin.password))) {
      throw new UnauthorizedException();
    }

    let newPassword = await bcrypt.hash(resetPassword.new_password, 10);

    admin.password = newPassword;
    return this.adminService.saveAdmin(admin);

  }



  async signInUser(
    username: string,
    pass: string
  ): Promise<{ access_token: string }> {
    const bcrypt = require("bcrypt");

    const user = await this.usersService.findOne({
      where: { username: username, deleted: false },
      relations: ['organization']
    });

    if (!user || !(await bcrypt.compare(pass, user.password))) {
      throw new UnauthorizedException();
    }
    const payload = { sub: user.id, username: user.username, type: user.type, organization: user.organization.id };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }

  async signUpUser(user: User) {
    return await this.usersService.createHashedUser(user);
  }

  async signInResearcher(
    username: string,
    pass: string
  ): Promise<{ access_token: string }> {
    const bcrypt = require("bcrypt");

    const researcher = await this.researcerService.findOne({
      where: { username: username, deleted: false },
      relations: ['organization']
    });
    if (!researcher || !(await bcrypt.compare(pass, researcher.password))) {
      throw new UnauthorizedException();
    }
    const payload = {
      sub: researcher.id,
      username: researcher.username,
      type: researcher.type,
      organization: researcher.organization.id
    };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }

  async signInAdmin(
    username: string,
    pass: string
  ): Promise<{ access_token: string }> {
    const bcrypt = require("bcrypt");

    const admin = await this.adminService.findOne({
      where: { username: username, deleted: false }
    });
    
    if (!admin || !(await bcrypt.compare(pass, admin.password))) {
      throw new UnauthorizedException();
    }
    
    const payload = {
      sub: admin.id,
      username: admin.username,
      type: admin.type
    };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }

  async signUpResearcher(researcher: Researcher) {
    return await this.researcerService.createHashedResearcher(researcher);
  }
}
