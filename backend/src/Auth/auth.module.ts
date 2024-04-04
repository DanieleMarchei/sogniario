import { Module } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { AuthController } from "./auth.controller";
import { UserModule } from "src/User/user.module";
import { AuthGuard } from "./auth.guard";
import { APP_GUARD } from "@nestjs/core";
import { ResearcherModule } from "src/Researcher/researcher.module";

@Module({
  imports: [UserModule, ResearcherModule],
  providers: [
    AuthService,
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
  ],
  controllers: [AuthController],
})
export class AuthModule {}
