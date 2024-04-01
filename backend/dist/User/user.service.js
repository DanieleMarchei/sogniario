"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const crud_typeorm_1 = require("@nestjsx/crud-typeorm");
const user_entity_1 = require("../entities/user.entity");
let UserService = class UserService extends crud_typeorm_1.TypeOrmCrudService {
    constructor(repo) {
        super(repo);
    }
    async createHashedUser(user) {
        const existingUser = await this.repo.findOne({
            where: { username: user.username },
        });
        if (existingUser) {
            throw new common_1.HttpException("Mail already used", common_1.HttpStatus.CONFLICT);
        }
        return this.repo.save(user);
    }
    async downloadDreams(organizationId) {
        var JSZip = require("jszip");
        let zip = new JSZip();
        let users = await this.repo.find({
            where: { organization: { id: organizationId } },
            relations: { dreams: true, psqis: true, chronotypes: true },
        });
        for (let user of users) {
            let dreamsCSV = this.convertToCSV(user.dreams);
            let chronotypesCSV = this.convertToCSV(user.chronotypes);
            let psqisCSV = this.convertToCSV(user.psqis);
            zip.folder(user.username).file("dreams.csv", dreamsCSV);
            zip.folder(user.username).file("chronotypes.csv", chronotypesCSV);
            zip.folder(user.username).file("psqis.csv", psqisCSV);
        }
        let data = await zip.generateAsync({ type: "uint8array" });
        return data;
    }
    convertToCSV(arr) {
        const array = [Object.keys(arr[0])].concat(arr);
        return array
            .map((row) => {
            return Object.values(row)
                .map((value) => {
                return typeof value === "string" ? JSON.stringify(value) : value;
            })
                .toString();
        })
            .join("\n");
    }
};
UserService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [Object])
], UserService);
exports.UserService = UserService;
//# sourceMappingURL=user.service.js.map