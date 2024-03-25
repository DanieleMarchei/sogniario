"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const typeorm_1 = require("@nestjs/typeorm");
const user_entity_1 = require("./entities/user.entity");
const user_module_1 = require("./User/user.module");
const dream_entity_1 = require("./entities/dream.entity");
const dream_module_1 = require("./Dream/dream.module");
const psqi_module_1 = require("./Psqi/psqi.module");
const chronotype_entity_1 = require("./entities/chronotype.entity");
const chronotype_module_1 = require("./Chronotype/chronotype.module");
const psqi_entity_1 = require("./entities/psqi.entity");
let AppModule = class AppModule {
};
AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({
                isGlobal: true,
            }),
            typeorm_1.TypeOrmModule.forRoot({
                type: "postgres",
                host: process.env.DATABASE_HOST,
                port: +process.env.DATABASE_PORT,
                username: process.env.DATABASE_USER,
                password: process.env.DATABASE_PASSWORD,
                database: process.env.DATABASE_NAME,
                entities: [user_entity_1.User, dream_entity_1.Dream, chronotype_entity_1.Chronotype, psqi_entity_1.Psqi],
                synchronize: true,
            }),
            user_module_1.UserModule,
            dream_module_1.DreamModule,
            psqi_module_1.PsqiModule,
            chronotype_module_1.ChronotypeModule,
        ],
        controllers: [],
        providers: [],
    })
], AppModule);
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map