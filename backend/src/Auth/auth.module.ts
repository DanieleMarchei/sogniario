import { Module } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { AuthController } from "./auth.controller";
import { UserModule } from "src/User/user.module";
import { AuthGuard } from "./auth.guard";
import { APP_GUARD } from "@nestjs/core";
import { ResearcherModule } from "src/Researcher/researcher.module";
import { ProtectAlterGuard, ProtectCreateGuard, ProtectCreateUserGuard, ProtectDeleteGuard, RolesGuard } from "./roles.guard";
import { AdminModule } from "src/Admin/admin.module";

@Module({
  imports: [UserModule, ResearcherModule, AdminModule],
  providers: [
    AuthService,
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
    {
      provide: APP_GUARD,
      useClass: RolesGuard,
    },
    {
      provide: APP_GUARD,
      useClass: ProtectCreateGuard,
    },
    {
      provide: APP_GUARD,
      useClass: ProtectCreateUserGuard,
    },
    {
      provide: APP_GUARD,
      useClass: ProtectDeleteGuard,
    },
    {
      provide: APP_GUARD,
      useClass: ProtectAlterGuard,
    },
  ],
  controllers: [AuthController],
})
export class AuthModule {}
