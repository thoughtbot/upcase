#line 1 "ext/redcloth_scan/redcloth_attributes.c.rl"
/*
 * redcloth_attributes.c.rl
 *
 * Copyright (C) 2009 Jason Garber
 */
#include <ruby.h>
#include "redcloth.h"

#line 15 "ext/redcloth_scan/redcloth_attributes.c.rl"



#line 15 "ext/redcloth_scan/redcloth_attributes.c"
static const char _redcloth_attributes_actions[] = {
	0, 1, 0, 1, 3, 1, 4, 1, 
	5, 1, 6, 1, 7, 1, 9, 1, 
	10, 1, 12, 1, 13, 1, 16, 1, 
	17, 1, 22, 1, 23, 1, 24, 2, 
	0, 9, 2, 2, 15, 2, 8, 20, 
	2, 9, 21, 2, 10, 11, 2, 13, 
	0, 2, 13, 1, 2, 13, 4, 2, 
	13, 5, 2, 13, 6, 2, 13, 7, 
	2, 13, 14, 2, 13, 18, 2, 13, 
	19, 3, 8, 9, 20, 3, 13, 0, 
	14, 3, 13, 0, 18, 3, 13, 0, 
	19, 3, 13, 1, 19, 3, 13, 4, 
	14, 3, 13, 4, 18, 3, 13, 4, 
	19
};

static const short _redcloth_attributes_key_offsets[] = {
	0, 0, 6, 11, 13, 14, 15, 23, 
	29, 34, 38, 46, 53, 60, 66, 72, 
	74, 82, 89, 90, 97, 103, 111, 118, 
	125, 131, 137, 142, 148, 156, 163, 170, 
	176, 182, 190, 197, 204, 210, 218, 225, 
	232, 238, 240, 242, 243, 244, 251, 257, 
	262, 270, 277, 284, 290, 292, 300, 307, 
	308, 315, 321, 323, 324, 331, 337, 345, 
	353, 359, 367, 375, 382, 389, 399, 406, 
	414, 422, 429, 436, 443, 450, 460, 466, 
	474, 482, 489, 496, 506, 513, 521, 529, 
	536, 543, 551, 559, 566, 573, 576, 582, 
	590, 598, 605, 612, 621, 629, 637, 644
};

static const char _redcloth_attributes_trans_keys[] = {
	0, 9, 10, 32, 11, 13, 0, 9, 
	32, 10, 13, 35, 41, 41, 41, 0, 
	32, 40, 46, 91, 123, 9, 13, 0, 
	9, 10, 32, 11, 13, 0, 9, 32, 
	10, 13, 0, 32, 9, 13, 0, 9, 
	10, 32, 35, 41, 11, 13, 0, 9, 
	32, 35, 41, 10, 13, 0, 9, 10, 
	32, 41, 11, 13, 0, 9, 32, 41, 
	10, 13, 0, 9, 10, 32, 11, 13, 
	91, 93, 0, 9, 10, 32, 91, 93, 
	11, 13, 0, 9, 32, 91, 93, 10, 
	13, 125, 0, 9, 10, 32, 125, 11, 
	13, 0, 9, 32, 125, 10, 13, 0, 
	9, 10, 32, 35, 41, 11, 13, 0, 
	9, 32, 35, 41, 10, 13, 0, 9, 
	10, 32, 41, 11, 13, 0, 9, 32, 
	41, 10, 13, 0, 9, 10, 32, 11, 
	13, 0, 9, 32, 10, 13, 0, 9, 
	10, 32, 11, 13, 0, 9, 10, 32, 
	35, 41, 11, 13, 0, 9, 32, 35, 
	41, 10, 13, 0, 9, 10, 32, 41, 
	11, 13, 0, 9, 32, 41, 10, 13, 
	0, 9, 10, 32, 11, 13, 0, 9, 
	10, 32, 91, 93, 11, 13, 0, 9, 
	32, 91, 93, 10, 13, 0, 9, 10, 
	32, 125, 11, 13, 0, 9, 32, 125, 
	10, 13, 0, 9, 10, 32, 91, 93, 
	11, 13, 0, 9, 32, 91, 93, 10, 
	13, 0, 9, 10, 32, 125, 11, 13, 
	0, 9, 32, 125, 10, 13, 35, 41, 
	35, 41, 41, 41, 0, 32, 40, 91, 
	123, 9, 13, 0, 9, 10, 32, 11, 
	13, 0, 9, 32, 10, 13, 0, 9, 
	10, 32, 35, 41, 11, 13, 0, 9, 
	32, 35, 41, 10, 13, 0, 9, 10, 
	32, 41, 11, 13, 0, 9, 32, 41, 
	10, 13, 91, 93, 0, 9, 10, 32, 
	91, 93, 11, 13, 0, 9, 32, 91, 
	93, 10, 13, 125, 0, 9, 10, 32, 
	125, 11, 13, 0, 9, 32, 125, 10, 
	13, 91, 93, 125, 0, 32, 40, 91, 
	123, 9, 13, 0, 9, 10, 32, 11, 
	13, 0, 9, 10, 32, 35, 41, 11, 
	13, 0, 9, 10, 32, 35, 41, 11, 
	13, 0, 9, 10, 32, 11, 13, 0, 
	9, 10, 32, 35, 41, 11, 13, 0, 
	9, 10, 32, 35, 41, 11, 13, 0, 
	9, 10, 32, 41, 11, 13, 0, 9, 
	10, 32, 41, 11, 13, 0, 9, 10, 
	32, 40, 46, 91, 123, 11, 13, 0, 
	9, 10, 32, 46, 11, 13, 0, 9, 
	10, 32, 91, 93, 11, 13, 0, 9, 
	10, 32, 91, 93, 11, 13, 0, 9, 
	10, 32, 125, 11, 13, 0, 9, 10, 
	32, 125, 11, 13, 0, 9, 10, 32, 
	41, 11, 13, 0, 9, 10, 32, 41, 
	11, 13, 0, 9, 10, 32, 40, 46, 
	91, 123, 11, 13, 0, 9, 10, 32, 
	11, 13, 0, 9, 10, 32, 35, 41, 
	11, 13, 0, 9, 10, 32, 35, 41, 
	11, 13, 0, 9, 10, 32, 41, 11, 
	13, 0, 9, 10, 32, 41, 11, 13, 
	0, 9, 10, 32, 40, 46, 91, 123, 
	11, 13, 0, 9, 10, 32, 46, 11, 
	13, 0, 9, 10, 32, 91, 93, 11, 
	13, 0, 9, 10, 32, 91, 93, 11, 
	13, 0, 9, 10, 32, 125, 11, 13, 
	0, 9, 10, 32, 125, 11, 13, 0, 
	9, 10, 32, 91, 93, 11, 13, 0, 
	9, 10, 32, 91, 93, 11, 13, 0, 
	9, 10, 32, 125, 11, 13, 0, 9, 
	10, 32, 125, 11, 13, 40, 91, 123, 
	0, 9, 10, 32, 11, 13, 0, 9, 
	10, 32, 35, 41, 11, 13, 0, 9, 
	10, 32, 35, 41, 11, 13, 0, 9, 
	10, 32, 41, 11, 13, 0, 9, 10, 
	32, 41, 11, 13, 0, 9, 10, 32, 
	40, 91, 123, 11, 13, 0, 9, 10, 
	32, 91, 93, 11, 13, 0, 9, 10, 
	32, 91, 93, 11, 13, 0, 9, 10, 
	32, 125, 11, 13, 0, 9, 10, 32, 
	125, 11, 13, 0
};

static const char _redcloth_attributes_single_lengths[] = {
	0, 4, 3, 2, 1, 1, 6, 4, 
	3, 2, 6, 5, 5, 4, 4, 2, 
	6, 5, 1, 5, 4, 6, 5, 5, 
	4, 4, 3, 4, 6, 5, 5, 4, 
	4, 6, 5, 5, 4, 6, 5, 5, 
	4, 2, 2, 1, 1, 5, 4, 3, 
	6, 5, 5, 4, 2, 6, 5, 1, 
	5, 4, 2, 1, 5, 4, 6, 6, 
	4, 6, 6, 5, 5, 8, 5, 6, 
	6, 5, 5, 5, 5, 8, 4, 6, 
	6, 5, 5, 8, 5, 6, 6, 5, 
	5, 6, 6, 5, 5, 3, 4, 6, 
	6, 5, 5, 7, 6, 6, 5, 5
};

static const char _redcloth_attributes_range_lengths[] = {
	0, 1, 1, 0, 0, 0, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 0, 
	1, 1, 0, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 0, 0, 0, 0, 1, 1, 1, 
	1, 1, 1, 1, 0, 1, 1, 0, 
	1, 1, 0, 0, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 0, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1
};

static const short _redcloth_attributes_index_offsets[] = {
	0, 0, 6, 11, 14, 16, 18, 26, 
	32, 37, 41, 49, 56, 63, 69, 75, 
	78, 86, 93, 95, 102, 108, 116, 123, 
	130, 136, 142, 147, 153, 161, 168, 175, 
	181, 187, 195, 202, 209, 215, 223, 230, 
	237, 243, 246, 249, 251, 253, 260, 266, 
	271, 279, 286, 293, 299, 302, 310, 317, 
	319, 326, 332, 335, 337, 344, 350, 358, 
	366, 372, 380, 388, 395, 402, 412, 419, 
	427, 435, 442, 449, 456, 463, 473, 479, 
	487, 495, 502, 509, 519, 526, 534, 542, 
	549, 556, 564, 572, 579, 586, 590, 596, 
	604, 612, 619, 626, 635, 643, 651, 658
};

static const unsigned char _redcloth_attributes_indicies[] = {
	0, 2, 3, 2, 0, 1, 0, 2, 
	2, 0, 1, 6, 7, 5, 4, 8, 
	10, 9, 4, 12, 13, 14, 15, 16, 
	4, 11, 17, 19, 20, 19, 17, 18, 
	17, 19, 19, 17, 18, 4, 12, 4, 
	11, 5, 22, 23, 22, 24, 25, 5, 
	21, 5, 22, 22, 24, 25, 5, 21, 
	9, 27, 28, 27, 29, 9, 26, 9, 
	27, 27, 29, 9, 26, 17, 19, 20, 
	30, 17, 11, 4, 32, 31, 31, 34, 
	35, 34, 18, 36, 31, 33, 31, 34, 
	34, 18, 36, 31, 33, 38, 37, 37, 
	40, 41, 40, 42, 37, 39, 37, 40, 
	40, 42, 37, 39, 5, 44, 45, 44, 
	46, 47, 5, 43, 5, 44, 44, 46, 
	47, 5, 43, 9, 49, 50, 49, 51, 
	9, 48, 9, 49, 49, 51, 9, 48, 
	17, 53, 54, 53, 17, 52, 17, 53, 
	53, 17, 52, 0, 2, 3, 56, 0, 
	55, 5, 58, 59, 58, 60, 61, 5, 
	57, 5, 58, 58, 60, 61, 5, 57, 
	9, 63, 64, 63, 65, 9, 62, 9, 
	63, 63, 65, 9, 62, 17, 53, 54, 
	66, 17, 55, 31, 68, 69, 68, 52, 
	70, 31, 67, 31, 68, 68, 52, 70, 
	31, 67, 37, 72, 73, 72, 74, 37, 
	71, 37, 72, 72, 74, 37, 71, 31, 
	76, 77, 76, 1, 78, 31, 75, 31, 
	76, 76, 1, 78, 31, 75, 37, 80, 
	81, 80, 82, 37, 79, 37, 80, 80, 
	82, 37, 79, 84, 85, 83, 88, 89, 
	87, 86, 90, 92, 91, 86, 86, 94, 
	95, 96, 86, 93, 97, 99, 100, 99, 
	97, 98, 97, 99, 99, 97, 98, 87, 
	102, 103, 102, 104, 105, 87, 101, 87, 
	102, 102, 104, 105, 87, 101, 91, 107, 
	108, 107, 109, 91, 106, 91, 107, 107, 
	109, 91, 106, 86, 111, 110, 110, 113, 
	114, 113, 98, 115, 110, 112, 110, 113, 
	113, 98, 115, 110, 112, 117, 116, 116, 
	119, 120, 119, 121, 116, 118, 116, 119, 
	119, 121, 116, 118, 123, 123, 122, 123, 
	124, 123, 123, 126, 127, 128, 123, 125, 
	129, 2, 3, 2, 129, 1, 131, 132, 
	133, 132, 134, 135, 131, 130, 136, 44, 
	45, 44, 46, 47, 136, 43, 137, 19, 
	20, 19, 137, 18, 139, 140, 141, 140, 
	142, 143, 139, 138, 5, 22, 23, 22, 
	24, 25, 5, 21, 8, 145, 146, 145, 
	18, 8, 144, 9, 27, 28, 27, 29, 
	9, 26, 137, 19, 20, 30, 13, 14, 
	15, 16, 137, 11, 137, 19, 20, 30, 
	14, 137, 11, 148, 149, 150, 149, 18, 
	18, 148, 147, 31, 34, 35, 34, 18, 
	36, 31, 33, 152, 153, 154, 153, 18, 
	152, 151, 37, 40, 41, 40, 42, 37, 
	39, 156, 157, 158, 157, 1, 156, 155, 
	159, 49, 50, 49, 51, 159, 48, 129, 
	2, 3, 56, 160, 161, 162, 163, 129, 
	55, 164, 53, 54, 53, 164, 52, 131, 
	166, 167, 166, 168, 169, 131, 165, 136, 
	58, 59, 58, 60, 61, 136, 57, 156, 
	171, 172, 171, 52, 156, 170, 159, 63, 
	64, 63, 65, 159, 62, 164, 53, 54, 
	66, 160, 161, 162, 163, 164, 55, 164, 
	53, 54, 66, 161, 164, 55, 174, 175, 
	176, 175, 52, 52, 174, 173, 177, 68, 
	69, 68, 52, 70, 177, 67, 179, 180, 
	181, 180, 52, 179, 178, 182, 72, 73, 
	72, 74, 182, 71, 174, 184, 185, 184, 
	1, 1, 174, 183, 177, 76, 77, 76, 
	1, 78, 177, 75, 179, 187, 188, 187, 
	1, 179, 186, 182, 80, 81, 80, 82, 
	182, 79, 189, 190, 191, 123, 192, 99, 
	100, 99, 192, 98, 83, 194, 195, 194, 
	196, 197, 83, 193, 87, 102, 103, 102, 
	104, 105, 87, 101, 90, 199, 200, 199, 
	98, 90, 198, 91, 107, 108, 107, 109, 
	91, 106, 192, 99, 100, 99, 94, 95, 
	96, 192, 93, 122, 202, 203, 202, 98, 
	98, 122, 201, 110, 113, 114, 113, 98, 
	115, 110, 112, 124, 205, 206, 205, 98, 
	124, 204, 116, 119, 120, 119, 121, 116, 
	118, 0
};

static const char _redcloth_attributes_trans_targs[] = {
	60, 61, 1, 2, 60, 3, 4, 6, 
	5, 5, 6, 64, 9, 65, 70, 71, 
	73, 60, 64, 7, 8, 66, 10, 11, 
	67, 69, 68, 12, 13, 69, 14, 15, 
	6, 72, 16, 17, 69, 18, 6, 74, 
	19, 20, 69, 63, 21, 22, 75, 77, 
	76, 23, 24, 77, 78, 25, 26, 78, 
	27, 80, 28, 29, 81, 83, 82, 30, 
	31, 83, 32, 86, 33, 34, 83, 88, 
	35, 36, 83, 90, 37, 38, 77, 92, 
	39, 40, 77, 42, 43, 45, 93, 42, 
	43, 45, 44, 44, 45, 94, 95, 100, 
	102, 93, 94, 46, 47, 96, 48, 49, 
	97, 99, 98, 50, 51, 99, 52, 45, 
	101, 53, 54, 99, 55, 45, 103, 56, 
	57, 99, 52, 0, 55, 61, 62, 89, 
	91, 60, 63, 3, 21, 22, 75, 77, 
	3, 60, 66, 3, 10, 11, 67, 69, 
	68, 12, 13, 72, 15, 16, 17, 74, 
	18, 19, 20, 76, 5, 23, 24, 5, 
	79, 84, 85, 87, 60, 80, 28, 29, 
	81, 83, 82, 30, 31, 86, 15, 33, 
	34, 15, 88, 18, 35, 36, 18, 90, 
	37, 38, 92, 39, 40, 41, 58, 59, 
	93, 96, 48, 49, 97, 99, 98, 50, 
	51, 101, 53, 54, 103, 56, 57
};

static const char _redcloth_attributes_trans_actions[] = {
	27, 19, 0, 0, 29, 0, 5, 5, 
	1, 0, 7, 46, 0, 81, 46, 81, 
	81, 25, 19, 0, 0, 67, 0, 0, 
	97, 52, 67, 0, 0, 55, 0, 0, 
	9, 67, 0, 0, 58, 0, 11, 67, 
	0, 0, 61, 70, 0, 0, 101, 52, 
	70, 0, 0, 55, 19, 0, 0, 46, 
	0, 67, 0, 0, 97, 52, 67, 0, 
	0, 55, 0, 67, 0, 0, 58, 67, 
	0, 0, 61, 70, 0, 0, 58, 70, 
	0, 0, 61, 1, 0, 0, 23, 0, 
	5, 5, 1, 0, 7, 46, 77, 77, 
	77, 21, 19, 0, 0, 64, 0, 0, 
	93, 52, 64, 0, 0, 55, 0, 9, 
	64, 0, 0, 58, 0, 11, 64, 0, 
	0, 61, 1, 0, 1, 49, 89, 89, 
	89, 40, 85, 31, 1, 1, 70, 19, 
	13, 37, 81, 1, 1, 1, 67, 19, 
	81, 1, 1, 81, 1, 1, 1, 81, 
	1, 1, 1, 85, 31, 1, 1, 13, 
	81, 46, 81, 81, 73, 81, 1, 1, 
	67, 19, 81, 1, 1, 81, 31, 1, 
	1, 13, 81, 31, 1, 1, 13, 85, 
	1, 1, 85, 1, 1, 3, 3, 3, 
	34, 77, 1, 1, 64, 19, 77, 1, 
	1, 77, 1, 1, 77, 1, 1
};

static const char _redcloth_attributes_to_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 15, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 43, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
};

static const char _redcloth_attributes_from_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 17, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 17, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
};

static const short _redcloth_attributes_eof_trans[] = {
	0, 1, 1, 5, 5, 5, 5, 18, 
	18, 5, 18, 18, 18, 18, 18, 5, 
	18, 18, 5, 18, 18, 1, 1, 1, 
	1, 18, 18, 1, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 1, 1, 1, 
	1, 0, 87, 87, 87, 87, 98, 98, 
	98, 98, 98, 98, 87, 98, 98, 87, 
	98, 98, 0, 0, 0, 130, 130, 130, 
	138, 138, 138, 138, 138, 138, 138, 138, 
	138, 138, 138, 130, 130, 130, 165, 165, 
	165, 165, 165, 165, 165, 165, 165, 165, 
	165, 130, 130, 130, 130, 0, 193, 193, 
	193, 193, 193, 193, 193, 193, 193, 193
};

static const int redcloth_attributes_start = 60;
static const int redcloth_attributes_error = 0;

static const int redcloth_attributes_en_inline = 93;
static const int redcloth_attributes_en_link_says = 60;

#line 18 "ext/redcloth_scan/redcloth_attributes.c.rl"


VALUE
redcloth_attribute_parser(machine, self, p, pe)
  int machine;
  VALUE self;
  char *p, *pe;
{
  int cs, act;
  char *ts = 0, *te = 0, *reg = 0, *bck = NULL, *eof = NULL;
  VALUE regs = rb_hash_new();

  
#line 395 "ext/redcloth_scan/redcloth_attributes.c"
	{
	cs = redcloth_attributes_start;
	ts = 0;
	te = 0;
	act = 0;
	}
#line 31 "ext/redcloth_scan/redcloth_attributes.c.rl"

  cs = machine;

  
#line 407 "ext/redcloth_scan/redcloth_attributes.c"
	{
	int _klen;
	unsigned int _trans;
	const char *_acts;
	unsigned int _nacts;
	const char *_keys;

	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	_acts = _redcloth_attributes_actions + _redcloth_attributes_from_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 12:
#line 1 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ts = p;}
	break;
#line 428 "ext/redcloth_scan/redcloth_attributes.c"
		}
	}

	_keys = _redcloth_attributes_trans_keys + _redcloth_attributes_key_offsets[cs];
	_trans = _redcloth_attributes_index_offsets[cs];

	_klen = _redcloth_attributes_single_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + _klen - 1;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( (*p) < *_mid )
				_upper = _mid - 1;
			else if ( (*p) > *_mid )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				goto _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _redcloth_attributes_range_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + (_klen<<1) - 2;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( (*p) < _mid[0] )
				_upper = _mid - 2;
			else if ( (*p) > _mid[1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				goto _match;
			}
		}
		_trans += _klen;
	}

_match:
	_trans = _redcloth_attributes_indicies[_trans];
_eof_trans:
	cs = _redcloth_attributes_trans_targs[_trans];

	if ( _redcloth_attributes_trans_actions[_trans] == 0 )
		goto _again;

	_acts = _redcloth_attributes_actions + _redcloth_attributes_trans_actions[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 0:
#line 5 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ reg = p; }
	break;
	case 1:
#line 6 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ bck = p; }
	break;
	case 2:
#line 7 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ STORE("text"); }
	break;
	case 3:
#line 8 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ CLEAR_REGS(); RESET_REG(); }
	break;
	case 4:
#line 10 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ STORE("class_buf"); }
	break;
	case 5:
#line 10 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{STORE("id_buf");}
	break;
	case 6:
#line 11 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ STORE("lang_buf"); }
	break;
	case 7:
#line 12 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ STORE("style_buf"); }
	break;
	case 8:
#line 23 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ STORE("name"); }
	break;
	case 9:
#line 24 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ STORE_B("name_without_attributes"); }
	break;
	case 13:
#line 1 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{te = p+1;}
	break;
	case 14:
#line 19 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{act = 1;}
	break;
	case 15:
#line 19 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{te = p;p--;{ SET_ATTRIBUTES(); }}
	break;
	case 16:
#line 19 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{{p = ((te))-1;}{ SET_ATTRIBUTES(); }}
	break;
	case 17:
#line 1 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{	switch( act ) {
	case 0:
	{{cs = 0; goto _again;}}
	break;
	case 1:
	{{p = ((te))-1;} SET_ATTRIBUTES(); }
	break;
	}
	}
	break;
	case 18:
#line 28 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{act = 2;}
	break;
	case 19:
#line 29 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{act = 3;}
	break;
	case 20:
#line 28 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{te = p;p--;{ SET_ATTRIBUTES(); }}
	break;
	case 21:
#line 29 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{te = p;p--;{ SET_ATTRIBUTE("name_without_attributes", "name"); }}
	break;
	case 22:
#line 28 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{{p = ((te))-1;}{ SET_ATTRIBUTES(); }}
	break;
	case 23:
#line 29 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{{p = ((te))-1;}{ SET_ATTRIBUTE("name_without_attributes", "name"); }}
	break;
	case 24:
#line 1 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{	switch( act ) {
	case 2:
	{{p = ((te))-1;} SET_ATTRIBUTES(); }
	break;
	case 3:
	{{p = ((te))-1;} SET_ATTRIBUTE("name_without_attributes", "name"); }
	break;
	}
	}
	break;
#line 598 "ext/redcloth_scan/redcloth_attributes.c"
		}
	}

_again:
	_acts = _redcloth_attributes_actions + _redcloth_attributes_to_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 10:
#line 1 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{ts = 0;}
	break;
	case 11:
#line 1 "ext/redcloth_scan/redcloth_attributes.c.rl"
	{act = 0;}
	break;
#line 615 "ext/redcloth_scan/redcloth_attributes.c"
		}
	}

	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	if ( p == eof )
	{
	if ( _redcloth_attributes_eof_trans[cs] > 0 ) {
		_trans = _redcloth_attributes_eof_trans[cs] - 1;
		goto _eof_trans;
	}
	}

	_out: {}
	}
#line 35 "ext/redcloth_scan/redcloth_attributes.c.rl"

  return regs;
}

VALUE
redcloth_attributes(self, str)
  VALUE self, str;
{
  StringValue(str);
  int cs = redcloth_attributes_en_inline;
  return redcloth_attribute_parser(cs, self, RSTRING_PTR(str), RSTRING_PTR(str) + RSTRING_LEN(str) + 1);
}

VALUE
redcloth_link_attributes(self, str)
  VALUE self, str;
{
  StringValue(str);
  int cs = redcloth_attributes_en_link_says;
  return redcloth_attribute_parser(cs, self, RSTRING_PTR(str), RSTRING_PTR(str) + RSTRING_LEN(str) + 1);
}