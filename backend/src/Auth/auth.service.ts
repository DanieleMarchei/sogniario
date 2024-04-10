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

@Injectable()
export class AuthService {
  constructor(
    private usersService: UserService,
    private researcerService: ResearcherService,
    private jwtService: JwtService
  ) {}

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

  async signUpResearcher(researcher: Researcher) {
    return await this.researcerService.createHashedResearcher(researcher);
  }
}
